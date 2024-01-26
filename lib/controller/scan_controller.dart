import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import 'camera_view_singleton.dart';

class ScanController extends GetxController{
  @override
  void onInit() {
    super.onInit();
    initPytorch();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> camera;

  RxList<ResultObjectDetection> detections = RxList<ResultObjectDetection>();
  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  bool isProcessingImage = false;

  initCamera(BuildContext context) async {
      camera = await availableCameras();
      cameraController = CameraController(camera[0], ResolutionPreset.high);
      await cameraController.initialize().then((_) {
        Size? previewSize = cameraController?.value.previewSize;

        CameraViewSingleton.inputImageSize = previewSize!;

        Size screenSize = MediaQuery.of(context).size;
        CameraViewSingleton.screenSize = screenSize;
        CameraViewSingleton.ratio = screenSize.width / previewSize.height;
      });

      cameraController.startImageStream((image) async {
        if (!isProcessingImage) {
          isProcessingImage = true;
          await objectDetector(image);
          isProcessingImage = false;
        }
      });

      isCameraInitialized(true);
      update();

  }



  Future<void> stopCamera() async {
    if (cameraController.value.isInitialized) {
      await cameraController.stopImageStream();
      await cameraController.dispose(); // 可以选择性地调用
    }
  }

  ModelObjectDetection? _objectModel;
  ClassificationModel? _imageModel;

  initPytorch() async{
      // String pathImageModel = "assets/models/model_classification.pt";
      //String pathCustomModel = "assets/models/custom_model.ptl";
      String pathObjectDetectionModel = "assets/models/best.torchscript";
      try {
        // _imageModel = await PytorchLite.loadClassificationModel(
        //     pathImageModel, 224, 224, 1000,
        //     labelPath: "assets/labels/label_classification_imageNet.txt");
        //_customModel = await PytorchLite.loadCustomModel(pathCustomModel);
        _objectModel = await PytorchLite.loadObjectDetectionModel(
            pathObjectDetectionModel, 1, 640, 640,
            labelPath: "assets/models/labels.txt",
            objectDetectionModelType: ObjectDetectionModelType.yolov8);
      } catch (e) {
        if (e is PlatformException) {
          print("only supported for android, Error is $e");
        } else {
          print("Error is $e");
        }
      }


  }

  objectDetector(CameraImage image) async {
    if (_objectModel != null) {
      try {
        Stopwatch stopwatch = Stopwatch()..start();
        List<ResultObjectDetection> newDetections = await _objectModel!.getCameraImagePrediction(
          image,
          0,
          minimumScore: 0.3,
          iOUThreshold: 0.3,
        );

        for (var detection in newDetections) {
          print("Object: ${detection.className}, Rect: left=${detection.rect.left}, top=${detection.rect.top}, width=${detection.rect.width}, height=${detection.rect.height}");
        }

        // 使用 assignAll 来更新 RxList
        detections.assignAll(newDetections);

        if (newDetections.isNotEmpty) {
          log("Detection took: ${stopwatch.elapsedMilliseconds}ms");
          log("Detected objects: $newDetections");
        }
      } catch (e) {
        log("Error during object detection: $e");
      } finally {
        update(); // 只在需要时更新 UI
      }
    }
  }
}

