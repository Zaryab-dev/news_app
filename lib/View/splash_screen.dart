import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/home_screen', (route) => false);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/splash_pic.jpg',
            fit: BoxFit.cover,
            height: size.height * 0.5,
            width: size.width * 1,
          ),
          SizedBox(height: size.height * 0.04,),
          Text('TOP HEADLINES', style: GoogleFonts.anton(letterSpacing: 1,color: CupertinoColors.systemGrey),),
          SizedBox(height: size.height * 0.04,),
          SpinKitFadingCircle(
            color: Colors.blue,
            size: 60,
          )
        ],
      ),
    );
  }
}
