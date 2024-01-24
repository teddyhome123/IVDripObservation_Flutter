import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage/homepage.dart';
import 'package:frontend/pages/camera/camera.dart';
import 'package:camera/camera.dart';

import 'camera/canera_view.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
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
        // CameraPage(cameras: _cameras!),
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
          setState(() {
            _currentIndex = index;
          });
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