import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/webview/adwebview.dart';

import 'package:get/get.dart';

import '../controllers/partnersignup_controller.dart';

class PartnersignupView extends GetView<PartnersignupController> {
  const PartnersignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: SizedBox(
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
                              text: 'Registration',
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
                    height: Get.height * 0.02,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191B41),
                      fontSize: Get.width * 0.05,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter vanue name'
                        : null,

                    controller: controller.usernameController
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
                                text: 'Enter Your Venu Name ',
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
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191B41),
                      fontSize: Get.width * 0.05,
                    ),
                    validator: (value) => controller.validateEmail(value)
                        ? null
                        : 'Please enter a valid Email',

                    controller: controller.emailController
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
                  Obx(() => TextFormField(
                        textAlign: TextAlign.center,
                        obscureText: !controller.isPasswordVisible
                            .value, // Toggle password visibility
                        style: TextStyle(
                          color: Color(0xFF191B41),
                          fontSize: Get.width * 0.05,
                        ),
                        validator: (value) => controller
                                .passwordValidation(value)
                            ? null
                            : 'Password must be at least 6 characters long and contain a number',
                        controller: controller.passwordController.value,
                        decoration: InputDecoration(
                          constraints:
                              BoxConstraints(maxWidth: Get.width * 0.85),
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
                          labelStyle: TextStyle(color: Color(0xFF191B41)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                BorderSide(color: Colors.lightGreenAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                BorderSide(color: Colors.lightGreenAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                BorderSide(color: Colors.lightGreenAccent),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: Get.width * .01),
                            child: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off, // Show/Hide icon
                                color: Colors.grey,
                              ),
                              onPressed: controller
                                  .togglePasswordVisibility, // Toggle visibility
                            ),
                          ),
                        ),
                      )),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191B41),
                      fontSize: Get.width * 0.05,
                    ),

                    controller: controller.phoneController
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
                                text: 'Enter Your Contact Number ',
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
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191B41),
                      fontSize: Get.width * 0.05,
                    ),

                    controller: controller.addressController
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
                                text: 'Enter Your Venue Address ',
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
                    height: Get.height * 0.02,
                  ),
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
                              controller.isCheck.value =
                                  value ?? false; // Toggle the value on change
                            },
                            activeColor: Colors
                                .lightGreenAccent, // The color when checked
                            checkColor:
                                Color(0xFF191B41), // The color of the checkmark
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
                            decoration:
                                TextDecoration.underline, // Underline the text
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
                  SizedBox(
                    height: Get.height * 0.07,
                    child: ElevatedButton(
                      onPressed: controller.signup,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Become ',
                              style: TextStyle(
                                fontSize: Get.width * 0.05,
                                color: Color(0xFF191B41),
                              ),
                            ),
                            TextSpan(
                              text: 'Free Y-Fi',
                              style: TextStyle(
                                fontSize: Get.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191B41),
                              ),
                            ),
                            TextSpan(
                              text: ' Partner',
                              style: TextStyle(
                                fontSize: Get.width * 0.05,
                                color: Color(0xFF191B41),
                              ),
                            ),
                          ],
                        ),
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
                    height: Get.height * 0.04,
                  ),
                ],
              ),
            ),
            Get.mediaQuery.viewInsets.bottom > 0
                ? SizedBox.shrink()
                : Positioned(
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
                              'https://ad.freeyfi.com/app_slots/registration.html',
                          adUrl: 'https://google.com'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
