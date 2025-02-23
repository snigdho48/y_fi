import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      
      body:  SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children:[
          
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              child: Center(
                child: Text('Ad 1080x200', style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
            height: (Get.height *200)/1920,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
             SizedBox(
              width: Get.width,
               child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           
                           children: <Widget>[
                Image.asset('assets/icon/app_logo.png'),
                SizedBox(height: 20),
                const Text(
                  'Free Y-Fi',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.lightGreenAccent),
                ),
                SizedBox(height: 20),
                Text(
                  'Connect - Engage - Earn',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                
                
                           ],
                         ),
             ),
        
        ]
        ),
      ),
      
    );
  }
}
