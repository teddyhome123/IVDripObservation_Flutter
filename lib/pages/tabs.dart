import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage/homepage.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

import '../controller/scan_controller.dart';
import 'camera/canera_view.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final ScanController controller = Get.find<ScanController>();
  int _currentIndex = 0;

  List<CameraDescription>? _cameras;
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    initCameras();
  }

  void initCameras() async {
    // _cameras = await availableCameras();
    setState(() {
      _pages = [
        const HomePage(),
        const CameraView(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pages == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Flutter App"),),
      body: _pages![_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            controller.initCamera(context);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraView()),
            );
          } else {
            setState(() {
              _currentIndex = index;
              if (index != 1) {
                controller.stopCamera();
              }
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首頁",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: "辨識",
          ),
        ],
      ),
    );
  }
}