import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/webview/adwebview.dart';

import 'package:get/get.dart';

import '../controllers/partnerlogin_controller.dart';

class PartnerloginView extends GetView<PartnerloginController> {
  const PartnerloginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body:  SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                            text: 'Partner',
                              style: TextStyle(
                                fontSize: Get.width * 0.07,
                                fontWeight: FontWeight.w200,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                fontSize: Get.width * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreenAccent,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox( 
                    height: Get.height * 0.04,
                  ),
                              TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF191B41),
                                  fontSize: Get.width * 0.05,
                                ),
                                validator: (value) => controller.validateEmail(value)
                                    ? null
                                    : 'Please enter a valid Email',
            
                    controller: controller.emailController.value,  // Accessing the value of Rx<TextEditingController>
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.85,
            
                      ),
            
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Center(
                        child:RichText(text:
                                  TextSpan(
            
                                    children: [
                                      TextSpan(
                                        text: 'Enter Your Email ',
                                        style: TextStyle(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF191B41),
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                 ),
                      ),
            
                      labelStyle: TextStyle(
                        color: Color(0xFF191B41),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent, // Light green border on focus
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent, // Light green border when enabled
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,  // White background
            
                    ),
                  ),
              
                   TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191B41),
                      fontSize: Get.width * 0.05,
                    ),
                    validator: (value) => controller.passwordValidation(value)
                        ? null
                        : 'Password must be at least 6 characters long and contain a number',
            
                    controller: controller.passwordController
                        .value, // Accessing the value of Rx<TextEditingController>
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.85,
                      ),
            
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Enter Your Password ',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF191B41),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            
                      labelStyle: TextStyle(
                        color: Color(0xFF191B41),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors
                              .lightGreenAccent, // Light green border on focus
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors
                              .lightGreenAccent, // Light green border when enabled
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // White background
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
            SizedBox(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: Get.width * 0.37,
                            height: Get.height * 0.05,
                            child: ElevatedButton(
                              onPressed: controller.login,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: Get.width * .05,
                                    color: Color(0xFF191B41)),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.lightGreenAccent,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.37,
                            height: Get.height * 0.05,
                            child: ElevatedButton(
                              onPressed: controller.signup,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: Get.width * .05,
                                    color: Color(0xFF191B41)),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.lightGreenAccent,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                ],
              ),
            ),
           Get.mediaQuery.viewInsets.bottom  > 0 ? SizedBox.shrink() :
            Positioned(
                      bottom: 0,
                      left: (Get.width - 320) / 2, // Centering the ad
                      child: AnimatedOpacity(
                        opacity: (MediaQuery.of(context).viewInsets.bottom > 0)
                            ? 0
                            : 1,
                        duration: Duration(
                            milliseconds:
                                MediaQuery.of(context).viewInsets.bottom > 0
                                    ? 0
                                    : 200),
                                           child: AdBanner(
                          width: 320,
                          height: 50,
                          content:
                              'https://creatives.reachableads.com/gozayan/320x50',
                          adUrl: 'https://google.com'),
                      ),
                    ),
          
          ],
        ),
      ),
    );
  }
}
