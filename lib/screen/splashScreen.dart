import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_33/global.dart';
import 'package:flutter_33/screen/mainScreen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    moveToMain();

    super.initState();
  }

  void moveToMain() {
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const MainScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset("$image_path/splash.png", fit: BoxFit.contain),
        ),
        const CircularProgressIndicator()
      ],
    ));
  }
}
