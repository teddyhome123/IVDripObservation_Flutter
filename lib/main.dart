import 'package:flutter/material.dart';
import 'package:frontend/pages/tabs.dart';
import 'package:get/get.dart';
import 'controller/scan_controller.dart';

void main() {
  Get.put(ScanController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Tabs(),
    );
  }
}


