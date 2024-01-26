import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/box_widget_file.dart';
import '../../controller/scan_controller.dart';


class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanController controller = Get.find<ScanController>();

    // 在构建 CameraPreview 前，检查控制器是否已初始化且未被销毁
    if (!controller.isCameraInitialized.value) {
      return const Center(child: Text("Loading Preview..."));
    }

    return GetBuilder<ScanController>(
      builder: (_) => _buildCameraPreview(controller),
    );
  }

  Widget _buildCameraPreview(ScanController controller) {
    // 构建 CameraPreview
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CameraPreview(controller.cameraController),
            ...controller.detections.map((detection) =>
                BoxWidget(result: detection)).toList(),
          ],
        ),
      ),
    );
  }
}

