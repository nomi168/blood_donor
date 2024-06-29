// ignore_for_file: use_build_context_synchronously, file_names

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  // bool submitValid = false;

  // /// Text editing controllers to get the value from text fields
  // final TextEditingController _emailcontroller = TextEditingController();
  // final TextEditingController _otpcontroller = TextEditingController();

  // // Declare the object
  // late EmailAuth emailAuth;
  // Map<String, String> remoteServerConfiguration = {
  //   'server': 'https://example.com',
  //   'tokenPath': '/token',
  //   'sendOtpPath': '/send_otp',
  //   'validateOtpPath': '/validate_otp',
  // };

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the package
  //   emailAuth = EmailAuth(
  //     sessionName: "Sample session",
  //   );

  //   /// Configuring the remote server
  //   emailAuth.config(remoteServerConfiguration);
  // }

  // /// a void function to verify if the Data provided is true
  // /// Convert it into a boolean function to match your needs.
  // void verify() {
  //   if (kDebugMode) {
  //     print(
  //         "OTP validation results >> ${emailAuth.validateOtp(recipientMail: _emailcontroller.value.text, userOtp: _otpcontroller.value.text)}");
  //   }
  // }

  // /// a void funtion to send the OTP to the user
  // /// Can also be converted into a Boolean function and render accordingly for providers
  // void sendOtp() async {
  //   bool result = await emailAuth.sendOtp(
  //       recipientMail: _emailcontroller.value.text, otpLength: 5);
  //   if (result) {
  //     setState(() {
  //       submitValid = true;
  //     });
  //   } else if (kDebugMode) {
  //     print("Error processing OTP requests, check server for logs");
  //   }
  // }

  // void SendOTP() async {
  //   EmailAuth(sessionName: 'Test Session');
  //   var res = await emailAuth.sendOtp(recipientMail: _emailcontroller.text);
  //   if (res) {
  //     print("Send OTP");
  //   } else {
  //     print('Invalid OTP1111');
  //   }
  // }

  // void VerifyOTP() {
  //   var res = emailAuth.validateOtp(
  //       recipientMail: _emailcontroller.text, userOtp: _otpcontroller.text);
  //   if (res) {
  //     print("Verify OTP");
  //   } else {
  //     print('Invalid OTP');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: email,
                          decoration:
                              const InputDecoration(hintText: "User Email")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          myauth.setConfig(
                              appEmail: "me@rohitchouhan.com",
                              appName: "Email OTP",
                              userEmail: email.text,
                              otpLength: 6,
                              otpType: OTPType.digitsOnly);
                          if (await myauth.sendOTP() == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP has been sent"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Oops, OTP send failed"),
                            ));
                          }
                        },
                        child: const Text("Send OTP")),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: otp,
                          decoration:
                              const InputDecoration(hintText: "Enter OTP")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (await myauth.verifyOTP(otp: otp.text) == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP is verified"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                            ));
                          }
                        },
                        child: const Text("Verify")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
