import 'package:flutter/material.dart';
import 'package:flossinow/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1600), () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "assets/icon/launch_image.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
