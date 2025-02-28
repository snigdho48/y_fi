import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/userlogin_controller.dart';

class UserloginView extends GetView<UserloginController> {
  const UserloginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              child: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Wellcome to',
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
                                text: 'Free Y-Fi',
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
                    SizedBox(height: Get.height * 0.02),
                    Image.asset('assets/icon/app_logo.png',
                        height: Get.height * 0.2),
                    SizedBox(height: Get.height * 0.02),

                    //             TextFormField(
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 color: Color(0xFF191B41),
                    //                 fontSize: Get.width * 0.05,
                    //               ),
                    //               validator: (value) => controller.isValidPhoneNumber(value)
                    //                   ? null
                    //                   : 'Please enter a valid phone number',

                    //   controller: controller.emailController.value,  // Accessing the value of Rx<TextEditingController>
                    //   decoration: InputDecoration(
                    //     constraints: BoxConstraints(
                    //       maxWidth: Get.width * 0.85,

                    //     ),

                    //     floatingLabelBehavior: FloatingLabelBehavior.never,
                    //     label: Center(
                    //       child:RichText(text:
                    //                 TextSpan(

                    //                   children: [
                    //                     TextSpan(
                    //                       text: 'Enter Your Phone ',
                    //                       style: TextStyle(
                    //                         fontSize: Get.width * 0.04,
                    //                         fontWeight: FontWeight.normal,
                    //                         color: Color(0xFF191B41),
                    //                         height: 1.5,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                ),
                    //     ),

                    //     labelStyle: TextStyle(
                    //       color: Color(0xFF191B41),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(40),
                    //       borderSide: BorderSide(
                    //         color: Colors.lightGreenAccent, // Light green border on focus
                    //       ),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(40),
                    //       borderSide: BorderSide(
                    //         color: Colors.lightGreenAccent, // Light green border when enabled
                    //       ),
                    //     ),
                    //     focusedErrorBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(40),
                    //       borderSide: BorderSide(
                    //         color: Colors.lightGreenAccent,
                    //       ),
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,  // White background

                    //   ),
                    // ),SizedBox(height: Get.height * 0.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 10,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Login With',
                                style: TextStyle(
                                  fontSize: Get.width * 0.05,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: Get.width * 0.04),

                        //   Column(
                        //                 children: [
                        //                   IconButton(
                        //                     icon: FaIcon(FontAwesomeIcons.envelope,
                        //                       color: Color(0xFF191B41),
                        //                       size: 18,
                        //                     ),
                        //                      style: ButtonStyle(
                        //                       backgroundColor:
                        //                           MaterialStateProperty.all(Colors.white),
                        //                     ),
                        //                     onPressed: () {

                        //                     },
                        //                   ),
                        //                   Text('Email', style: TextStyle(
                        //                           fontSize: 10,
                        //                           color: Colors.lightGreenAccent)),
                        //                 ],
                        //               ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            //  Column(
                            //                   children: [
                            //                     IconButton(
                            //                       icon: FaIcon(
                            //                         FontAwesomeIcons.facebook,
                            //                         color: Color(0xFF191B41),
                            //                         size: 18,
                            //                       ),
                            //                       style: ButtonStyle(
                            //                         backgroundColor:
                            //                             MaterialStateProperty.all(Colors.white),
                            //                       ),
                            //                       onPressed: () {
                            //                         controller.loginWithFacebook();
                            //                       },
                            //                     ),
                            //                     Text('facebook',
                            //                         style: TextStyle(
                            //                             fontSize: 10,
                            //                             color: Colors.lightGreenAccent)),
                            //                   ],
                            //                 ),
                            Column(
                              children: [
                                IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Color(0xFF191B41),
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    controller.loginWithGoogle();
                                  },
                                ),
                                Text('Google',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.lightGreenAccent)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Obx(
                          () => Transform.scale(
                            scale: 1.5, // Scales the checkbox
                            child: Checkbox(
                              value: controller.isCheck.value,
                              onChanged: (value) {
                                controller.isCheck.value = value ??
                                    false; // Toggle the value on change
                              },
                              activeColor: Colors
                                  .lightGreenAccent, // The color when checked
                              checkColor: Color(
                                  0xFF191B41), // The color of the checkmark
                              fillColor: controller.isCheck.value
                                  ? MaterialStateProperty.all(
                                      Colors.lightGreenAccent)
                                  : null, // The color when unchecked
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(
                                  color: Colors
                                      .white), // Border color of the checkbox
                            ),
                          ),
                        ),

                        // This makes the text take up the remaining space
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Click to accept',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                'Terms & Conditions', // Adds some extra space between the text and underline
                            style: TextStyle(
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration
                                  .underline, // Underline the text
                              decorationColor: Colors
                                  .white, // Optional: Set the underline color
                              decorationStyle:
                                  TextDecorationStyle.solid, // Solid underline
                              decorationThickness: 1,
                              height:
                                  1.5, // This adjusts the vertical spacing for the underline
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(
                        //   width: Get.width * 0.37,
                        //   height: Get.height * 0.05,
                        //   child: ElevatedButton(
                        //     onPressed: controller.login,

                        //     child: Text('User Login', style: TextStyle(fontSize: Get.width*.05,color: Color(0xFF191B41)),),
                        //     style: ButtonStyle(

                        //       backgroundColor: MaterialStateProperty.all(
                        //         Colors.lightGreenAccent,
                        //       ),
                        //       shape: MaterialStateProperty.all(
                        //         RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(40),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // SizedBox(
                        //     width: Get.width * 0.37,
                        //   height: Get.height * 0.05,
                        //   child: ElevatedButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       'Partner Login',
                        //       style: TextStyle(
                        //           fontSize: Get.width*.05, color: Color(0xFF191B41)),
                        //     ),
                        //     style: ButtonStyle(
                        //       backgroundColor: MaterialStateProperty.all(
                        //         Colors.lightGreenAccent,
                        //       ),
                        //       shape: MaterialStateProperty.all(
                        //         RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(40),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Fixed Positioned Banner
            Positioned(
              bottom: 0,
              left: 0,
              child: AnimatedOpacity(
                opacity: (MediaQuery.of(context).viewInsets.bottom > 0) ? 0 : 1,
                duration: Duration(
                    milliseconds:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 200),
                child: Container(
                  height: (Get.height * 200) / 1920,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'Ad 1080x200',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
