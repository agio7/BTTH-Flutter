// lib/main.dart
import 'package:flutter/material.dart';
import 'package:th_buoi3/RegisterPage.dart';

import 'AddAddressScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Đăng Ký',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AddAddressScreen(), // Bắt đầu với màn hình đăng ký
    );
  }
}
