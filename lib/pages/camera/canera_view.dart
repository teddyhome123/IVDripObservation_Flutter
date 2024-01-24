import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controller/scan_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  Positioned(
                    top: 100,
                    right: 100,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red, width: 4.0),
                      ),
                      child:  Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Text(controller.label)
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
              : const Center(child: Text("Loding Preview..."),);
        }
      ),
    );
  }
}
