import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/presentation/controllers/signup_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/login_screen.dart';
import 'package:blood_donor/features/auth/presentation/screens/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<SignupController>(
          init: SignupController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Form(
                key: controller.formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(1),
                          child: CircleAvatar(
                            radius: 50,
                            // ignore: unnecessary_null_comparison
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : const NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAYLB3IWsTasUT1Kt1-UeUbzXQPQZDufxUkA&usqp=CAU')
                                    as ImageProvider<Object>?,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () async {
                            await controller.showPickerOptions(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5.h, right: 3.w),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        child: TextFormField(
                          controller: controller.fname,
                          decoration: InputDecoration(
                            label: const Text(
                              'First Name',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            // hintText: 'First Name',
                          ),
                          validator: validateFirstName,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .then(delay: 200.ms) // baseline=800ms
                          .slide(begin: Offset(1, 0), end: Offset.zero),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        color: Colors.white,
                        elevation: 2.5, // Add shadow/elevation
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          controller: controller.lname,
                          decoration: InputDecoration(
                            label: const Text(
                              'Last Name',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .white), // Border color when focused
                            ),
                            // hintText: 'Last Name',
                          ),
                          validator: validateLastName,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .then(delay: 200.ms) // baseline=800ms
                          .slide(begin: Offset(1, 0), end: Offset.zero),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      child: IntlPhoneField(
                        controller: controller.phonenumber,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.8, color: Colors.black26),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        initialCountryCode:
                            'PK', // Set the default country code
                        onChanged: (phone) {
                          controller.phone = phone
                              .completeNumber; // Store the full number with country code
                        },
                        onCountryChanged: (country) {
                          // Update the text field with the new country code

                          controller.phonenumber.text = '+${country.dialCode}';
                        },
                        validator: (phoneNumber) {
                          if (phoneNumber == null ||
                              phoneNumber.number.isEmpty) {
                            return 'Phone number is required';
                          }

                          return null; // Return null for valid input
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        color: Colors.white,
                        elevation: 2.5, // Add shadow/elevation
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          controller: controller.email,
                          decoration: InputDecoration(
                            label: const Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.red), // Border color
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .white), // Border color when focused
                            ),
                            // hintText: 'Email',
                          ),
                          validator: validateEmail,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.w,
                      ),
                      child: Material(
                        color: Colors.white,
                        elevation: 2.5, // Add shadow/elevation
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          controller: controller.location,
                          decoration: InputDecoration(
                            label: const Text(
                              'Location',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .white), // Border color when focused
                            ),
                            // hintText: 'Location',
                          ),
                          validator: validateLocation,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Must be enter complete address with city name!',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        color: Colors.white,
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                            labelText: "Blood Group",
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          items: controller.nomi1
                              .map((e) => DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          validator: validateBlood,
                          onChanged: (v) {
                            controller.selectedIndex1 = v!;
                          },
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        color: Colors.white,
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                            labelText: "Gender",
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          items: controller.nomi
                              .map((e) => DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          validator: validateGender,
                          onChanged: (v) {
                            controller.selectedIndex = v!;
                          },
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Material(
                              color: Colors.white,
                              elevation: 2.5,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextFormField(
                                controller: controller.password,
                                obscureText: controller
                                    .obscureText, // Set to true to obscure text
                                decoration: InputDecoration(
                                  label: const Text('New',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black45)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  // hintText: 'New Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 22,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      controller.obscureText =
                                          !controller.obscureText;
                                      controller.update();
                                    },
                                  ),
                                ),
                                validator: validatePassword,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .then(delay: 200.ms) // baseline=800ms
                            .slide(begin: Offset(1, 0), end: Offset.zero),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Container(
                            child: Material(
                              color: Colors.white,
                              elevation: 2.5,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextFormField(
                                controller: controller.conpassword,
                                obscureText: controller
                                    .obscureText1, // Set to true to obscure text
                                decoration: InputDecoration(
                                  label: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black45),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  // hintText: 'Confirm',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        controller.obscureText1
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 22,
                                        color: Colors.black45),
                                    onPressed: () {
                                      controller.obscureText1 =
                                          !controller.obscureText1;
                                      controller.update();
                                    },
                                  ),
                                ),
                                // validator: validatePassword,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .then(delay: 200.ms) // baseline=800ms
                            .slide(begin: Offset(1, 0), end: Offset.zero),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () async {
                        if (controller.image != null) {
                          if (controller.phonenumber.text.isNotEmpty) {
                            if (controller.password.text.toString() ==
                                controller.conpassword.text.toString()) {
                              if (controller.formkey.currentState != null &&
                                  controller.formkey.currentState!.validate()) {
                                bool reult = await controller
                                    .checkEmail(controller.email.text.trim());
                                if (reult) {
                                  dynamic payload = {
                                    'firstname': controller.fname.text.trim(),
                                    'lastname': controller.lname.text.trim(),
                                    'phonenumber':
                                        '0${controller.phonenumber.text.trim()}',
                                    'email': controller.email.text.trim(),
                                    'location': controller.location.text.trim(),
                                    'bloodgroup': controller.selectedIndex1,
                                    'gender': controller.selectedIndex,
                                    'password': controller.password.text.trim(),
                                    'image': controller.image,
                                  };
                                  showCustomSnackBar(
                                      context, "email is valid", true);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return OtpScreen(
                                          payload: payload,
                                        );
                                      },
                                      transitionDuration:
                                          const Duration(microseconds: 300),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(10.0,
                                            0.0); // slide in from the right
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutQuart;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  // Get.snackbar(
                                  //   "Warning",
                                  //   "Two items with same id!",
                                  //   snackPosition: SnackPosition.BOTTOM,
                                  //   duration: const Duration(seconds: 2),
                                  //   colorText: Colors.white,
                                  // );

                                  showCustomSnackBar(
                                      context,
                                      "This Email is already Exist. Please try another email!",
                                      false);

                                  controller.email.clear();
                                }
                              }
                            } else {
                              showCustomSnackBar(context,
                                  "please enter valid password!", false);
                            }
                          } else {
                            showCustomSnackBar(
                                context, "please enter phone number!", false);
                          }
                        } else {
                          showCustomSnackBar(
                              context, "must be upload image", false);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(06),
                            color: PRIMARY_COLOR),
                        child: Text(
                          'validate',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const LoginScreen();
                                },
                              ),
                            );
                          },
                        )
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(begin: Offset(1, 0), end: Offset.zero)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
