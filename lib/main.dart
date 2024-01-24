import 'package:flutter/material.dart';
import 'package:frontend/router.dart';
import 'package:frontend/pages/homepage/homepage.dart';
import 'package:frontend/pages/tabs.dart';
import 'package:get/get.dart';

void main() {
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
      // initialRoute: MyRouter.home,
      // routes: {
      //   MyRouter.home: (context) => const HomePage(), // 修改的地方
      // },
    );
  }
}


