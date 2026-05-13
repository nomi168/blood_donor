import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/card_scanning_controller.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CardScanningScreen extends StatefulWidget {
  const CardScanningScreen({super.key});

  @override
  State<CardScanningScreen> createState() => _CardScanningScreenState();
}

class _CardScanningScreenState extends State<CardScanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 25),
            child: GetBuilder<CardScanningController>(
              init: CardScanningController(),
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black54),
                          onPressed: () {
                            Navigator.of(context).pop(); // Go back
                          },
                        ),

                        // Title in center
                        Expanded(
                          child: Text(
                            'Verification Process',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        SizedBox(width: 48),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: SvgPicture.asset(
                        height: 130.h,
                        width: 130.w,
                        'images/svg/Layer_1.svg',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Setting Up your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),

                    SizedBox(
                      height: 4.h,
                    ),
                    _customRow(controller, 1, 'Email verified', showIcon: true),
                    SizedBox(
                      height: 3.h,
                    ),
                    _customRow(controller, 2, 'Checking up your CNIC'),
                    // SizedBox(
                    //   height: 3.h,
                    // ),
                    // _customRow(3, 'Verifying your address'),
                    SizedBox(height: 3.h),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text('Scan or enter CNIC details',
                          style: TextStyle(
                              color: Color(kDarkGreyColor),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                          textAlign: TextAlign.center,
                          'To verify your account, please enter your CNIC details and ensure you scan both the front and back sides of your CNIC card.',
                          style: TextStyle(
                              color: Color(kLightGreyColor),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500)),
                    ),

                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Column(
                        children: [
                          _dataField(
                              text: 'Name',
                              textEditingController:
                                  controller.nameTEController),
                          _cnicField(
                              textEditingController:
                                  controller.cnicTEController),
                          Row(
                            children: [
                              Expanded(
                                child: _dataField(
                                    text: 'Date of Birth',
                                    textEditingController:
                                        controller.dobTEController),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: _dataField(
                                    text: 'Date of Card Issue',
                                    textEditingController:
                                        controller.doiTEController),
                              ),
                            ],
                          ),

                          _dataField(
                              text: 'Date of Card Expire',
                              textEditingController:
                                  controller.doeTEController),
                          SizedBox(
                            height: 5.w,
                          ),
                          Row(
                            children: [
                              Expanded(child: _getScanCNICBtn(controller)),
                              controller.cnicTEController.text.isNotEmpty
                                  ? SizedBox(
                                      width: 10.w,
                                    )
                                  : SizedBox(),
                              controller.cnicTEController.text.isNotEmpty
                                  ? Expanded(
                                      child: InkWell(
                                      splashColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: () async {
                                        String cnicNumber = controller
                                            .cnicTEController.text
                                            .trim()
                                            .replaceAll('-', '');

                                        controller.correctcnic = true;
                                        controller.update();
                                        dynamic payload = {
                                          'email': UserController
                                              .to.userModel!.email,
                                          'card_user_name': controller
                                              .nameTEController.text
                                              .trim(),
                                          'card_number': cnicNumber,
                                          'date_of_birth': controller
                                              .dobTEController.text
                                              .trim(),
                                          'date_of_cardissue': controller
                                              .doiTEController.text
                                              .trim(),
                                          'date_of_cardexpire': controller
                                              .doeTEController.text
                                              .trim(),
                                          'card_image': "",
                                        };
                                        bool result = controller.isEligible(
                                            dob:
                                                controller.dobTEController.text,
                                            doi:
                                                controller.doiTEController.text,
                                            );
                                        if (result == true) {
                                          bool? response = await controller
                                              .addCnicCardDetail(payload);
                                          if (response == true) {
                                            Get.snackbar(
                                              "Success",
                                              "complete verification successfully",
                                              snackPosition: SnackPosition.TOP,
                                              snackStyle: SnackStyle.FLOATING,
                                              backgroundColor: Colors.green
                                                  .withValues(alpha: 0.9),
                                              colorText: Colors.white,
                                              margin: EdgeInsets.all(10),
                                              duration: Duration(seconds: 3),
                                              borderRadius: 8,
                                              icon: Icon(Icons.check_circle,
                                                  color: Colors.white),
                                            );

                                            Navigator.of(context).pop();
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "Error while adding CNIC",
                                              snackPosition: SnackPosition.TOP,
                                              snackStyle: SnackStyle.FLOATING,
                                              backgroundColor: Colors.red
                                                  .withValues(alpha: 0.9),
                                              colorText: Colors.white,
                                              margin: EdgeInsets.all(10),
                                              duration: Duration(seconds: 3),
                                              borderRadius: 8,
                                              icon: Icon(Icons.error,
                                                  color: Colors.white),
                                            );
                                          }
                                        } else {
                                          controller.showNotEligibleDialog(
                                            userType: UserController
                                                .to
                                                .userModel!
                                                .type, 
                                          );
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(08),
                                            color: PRIMARY_COLOR),
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // _submitButton(),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _customRow(CardScanningController controller, int index, String value,
      {bool showIcon = false}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.red.shade100.withValues(alpha: 0.5),
              ),
              child: showIcon
                  ? Icon(
                      Icons.check, // Replace with the desired icon
                      color: Colors.black,
                      size: 18.sp,
                    )
                  : controller.correctcnic == true
                      ? Icon(
                          Icons.check, // Replace with the desired icon
                          color: Colors.black,
                          size: 18.sp,
                        )
                      : Text(
                          index.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 15.sp,
              ),
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black45,
          ),
        )
      ],
    );
  }

  Widget _getScanCNICBtn(CardScanningController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(onCameraBTNPressed: () {
                controller.scanCnic(ImageSource.camera);
              }, onGalleryBTNPressed: () {
                controller.scanCnic(ImageSource.camera);
                // Get.snackbar(
                //   "Error",
                //   "You are not allow to scan Cnic from gallary",
                //   snackPosition: SnackPosition.TOP,
                //   snackStyle: SnackStyle.FLOATING,
                //   backgroundColor: Colors.red.withValues(alpha: 0.9),
                //   colorText: Colors.white,
                //   margin: EdgeInsets.all(10),
                //   duration: Duration(seconds: 3),
                //   borderRadius: 8,
                //   icon: Icon(Icons.error, color: Colors.white),
                // );

                // scanCnic(ImageSource.gallery);
              });
            });
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('Scan CNIC',
            style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  Widget _cnicField({required TextEditingController textEditingController}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(08),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin:
          const EdgeInsets.only(top: 7.0, bottom: 1.0, left: 0.0, right: 0.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CNIC Number',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.card_membership,
                        color: Colors.red,
                      ),
                      // Image.asset("assets/images/cnic.png",
                      //     width: 40, height: 30),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: '3700-0000000-0',
                            hintStyle: TextStyle(color: Color(kLightGreyColor)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 5.0),
                          ),
                          style: TextStyle(
                              color: Color(kDarkGreyColor),
                              fontWeight: FontWeight.bold),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _dataField(
      {required String text,
      required TextEditingController textEditingController}) {
    return Container(

        // shadowColor: Color(kShadowColor),
        // elevation: 5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(08),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                (text == "Name") ? Icons.person : Icons.date_range,
                color: Colors.red,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextField(
                      readOnly: true,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: (text == "Name") ? "User Name" : 'DD/MM/YYYY',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                            color: Color(kLightGreyColor),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.all(0),
                      ),
                      style: TextStyle(
                          color: Color(kDarkGreyColor),
                          fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.done,
                      keyboardType: (text == "Name")
                          ? TextInputType.text
                          : TextInputType.number,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
