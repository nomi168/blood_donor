import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/questions_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class QuestionsScreen extends StatelessWidget {
  Map<String, dynamic> payload;
  QuestionsScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: GetBuilder<QuestionsController>(
                init: QuestionsController(),
                builder: (controller) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            'Questionnaires',
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          // Spacer(),
                          InkWell(
                            splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {
                              controller.isUrdu = !controller.isUrdu;
                              controller.update();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  border: Border.all(color: PRIMARY_COLOR),
                                  borderRadius: BorderRadius.circular(05)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                controller.isUrdu
                                    ? 'Switch to English'
                                    : 'Switch to Urdu',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          'Fill up the following Questionnaires and become a donor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: buildQuestionContainer(
                                    controller,
                                    controller.isUrdu
                                        ? 'کیا آپ کو ذیابیطس ہے؟'
                                        : 'Do you have diabetes?',
                                    controller.Q1, (value) {
                                  controller.Q1 = value!;
                                  controller.update();
                                }),
                              ),
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: buildQuestionContainer(
                                controller,
                                controller.isUrdu
                                    ? 'کیا آپ کو کبھی دل یا پھیپھڑوں کے مسائل ہوئے ہیں؟'
                                    : 'Have you ever had problems with your heart or lungs?',
                                controller.Q2, (value) {
                              controller.Q2 = value!;
                              controller.update();
                            }),
                          ),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 5,
                          ),
                          buildQuestionContainer(
                              controller,
                              controller.isUrdu
                                  ? 'کیا آپ کو پچھلے 28 دنوں میں کوویڈ 19 ہوا ہے؟'
                                  : 'In the last 28 days have you had COVID-19?',
                              controller.Q3, (value) {
                            controller.Q3 = value!;
                            controller.update();
                          }),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: buildQuestionContainer(
                                controller,
                                controller.isUrdu
                                    ? 'کیا آپ کا کبھی ایچ آئی وی/ایڈز وائرس کے لیے ٹیسٹ مثبت آیا ہے؟'
                                    : 'Have you ever had a positive test for the HIV/AIDS virus?',
                                controller.Q4, (value) {
                              controller.Q4 = value!;
                              controller.update();
                            }),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: buildQuestionContainer(
                                    controller,
                                    controller.isUrdu
                                        ? 'کیا آپ کو کبھی کینسر ہوا ہے؟'
                                        : 'Have you ever had cancer?',
                                    controller.Q5, (value) {
                                  controller.Q5 = value!;
                                  controller.update();
                                }),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: buildQuestionContainer(
                                    controller,
                                    controller.isUrdu
                                        ? 'کیا آپ نے پچھلے 3 ماہ میں کوئی ویکسین لگوائی ہے؟'
                                        : 'In the last 3 months have you had a vaccination?',
                                    controller.Q6, (value) {
                                  controller.Q6 = value!;
                                  controller.update();
                                }),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2.w, 0.h, 0.w, 0),
                            child: Checkbox(
                              value: controller.type == 'Yes',
                              checkColor: Colors.white,
                              focusColor: Colors.red,
                              activeColor: Colors.red,

                              // Check if ttype is 'donor'
                              onChanged: (bool? value) {
                                controller.type = value == true ? 'Yes' : '';
                                controller.terms = true;
                                controller.update();
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'By clicking, you agree to our terms and codition',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.type == 'Yes') {
                              if (controller.Q1.isNotEmpty &&
                                  controller.Q2.isNotEmpty &&
                                  controller.Q3.isNotEmpty &&
                                  controller.Q4.isNotEmpty &&
                                  controller.Q5.isNotEmpty &&
                                  controller.Q6.isNotEmpty) {
                                if (controller.Q1 == 'Yes' ||
                                    controller.Q2 == 'Yes' ||
                                    controller.Q4 == 'Yes' ||
                                    controller.Q5 == 'Yes') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text(
                                          'You are not eligible to donate blood. You can only receive blood.\n'
                                          'Click the OK button to create a basic account.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              controller.payload
                                                  .assignAll(payload);
                                              final newPayload = {
                                                'deviceToken':
                                                    controller.token.toString(),
                                                'type': 'taker',
                                                'status': false,
                                                'availabledonate': false,
                                              };
                                              controller.payload
                                                  .addAll(newPayload);

                                              // payload.addEntries(newPayload.entries);
                                              logSuccess(
                                                  'JSON: ${controller.payload}');

                                              bool result = await controller
                                                  .addUser(controller.payload,
                                                      flag: false);
                                              if (result) {
                                                Get.offAll(() => Dashboard());

                                                SharedPreferences _pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String? id =
                                                    _pref.getString('user_uid');
                                                String name =
                                                    '${payload['firstname']} ${payload['lastname']}';
                                                controller.usereligible(id!,
                                                    flag: false);
                                                controller.userAddLocation(id,
                                                    name, payload['location']);
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  controller.payload.assignAll(payload);
                                  final newPayload = {
                                    'deviceToken': controller.token.toString(),
                                    'type': 'donor',
                                    'status': false,
                                    'availabledonate': false,
                                  };
                                  controller.payload.addAll(newPayload);

                                  // payload.addEntries(newPayload.entries);
                                  logSuccess('JSON: ${controller.payload}');

                                  bool result = await controller
                                      .addUser(controller.payload, flag: false);
                                  if (result) {
                                    Get.offAll(() => Dashboard());
                                    SharedPreferences _pref =
                                        await SharedPreferences.getInstance();
                                    String? id = _pref.getString('user_uid');
                                    String name =
                                        '${payload['firstname']} ${payload['lastname']}';
                                    controller.usereligible(id!, flag: true);
                                    controller.userAddLocation(
                                        id, name, payload['location']);
                                  }
                                }
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "You must check the questionnaires.",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: Icon(Icons.error, color: Colors.white),
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please must be check Terms and Conditions.",
                                snackPosition: SnackPosition.TOP,
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor:
                                    Colors.red.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                duration: Duration(seconds: 3),
                                borderRadius: 8,
                                icon: Icon(Icons.error, color: Colors.white),
                              );
                            }
                          },
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              // ignore: prefer_const_constructors
                              EdgeInsets.symmetric(
                                  vertical: 13.5, horizontal: 35.w),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xFFDE0A1E)), // Change button color
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                }),
          ),
        ));
  }

  Widget buildQuestionContainer(QuestionsController controller, String question,
      String groupValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            question,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(controller.isUrdu ? 'ہاں' : 'Yes'),
                value: 'Yes',
                activeColor: PRIMARY_COLOR,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(controller.isUrdu ? 'نہیں' : 'No'),
                value: 'No',
                activeColor: PRIMARY_COLOR,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
