import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftchat/widget/chat_page.dart';

void main() {
  HttpOverrides.global = NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록
  runApp(const MyApp());
}
class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo111',
      theme: ThemeData(
        primarySwatch: Colors.amber ,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatPage(),
    );
  }
}