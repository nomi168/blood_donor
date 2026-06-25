import 'package:blood_donor/common/widgets/text_field_widget.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/controllers/post_request_controller.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/screens/map_request_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PostRequestScreen extends StatelessWidget {
  final String? blood;

  const PostRequestScreen({super.key, this.blood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<PostRequestController>(
            init: PostRequestController(bloodgroup: blood!),
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        Text(
                          'Post Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.black),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                    _buildText('Hospital'),
                    SizedBox(
                      height: 1.h,
                    ),
                    CustomTextField(
                      controller: controller.hospital,
                      label: 'Search Hospital',
                      hintText: 'Search Hospital',
                      validator: validateHospital,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    _buildText('Blood-Type'),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: Colors.white,
                        decoration: customDecoration(
                            hint: "Select Blood Type",
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                        items: controller.bloodType
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedBlood = value!;
                          controller.update();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText('Date'),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 3.w),
                                child: TextFormField(
                                  controller: TextEditingController(
                                    text: "${controller.selectedDate.toLocal()}"
                                        .split(' ')[0],
                                  ),
                                  readOnly: true,
                                  decoration: customDecoration(
                                    hint: "MM/DD/YYYY",
                                    suffixIcon:
                                        Icon(Icons.calendar_month_outlined),
                                  ),
                                  onTap: () => controller.selectDate(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText('Time'),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3.w, left: 2.w),
                                child: TextFormField(
                                  controller: TextEditingController(
                                    // ignore: unnecessary_string_interpolations
                                    text:
                                        "${controller.selectedTime.format(context)}",
                                  ),
                                  readOnly: true,
                                  decoration: customDecoration(
                                    hint: "00:00",
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                  onTap: () => controller.selectTime(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    _buildText('Address'),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      child: TextFormField(
                        validator: validateAddress,
                        controller: controller.location,
                        decoration: customDecoration(
                          hint: "Select Address",
                          suffixIcon: controller.isLoading
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 1.h,
                                      width: 1.w,
                                    ),
                                    CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: PRIMARY_COLOR,
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () {
                                    controller.getCurrentAddress();
                                  },
                                  splashColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    child: Icon(
                                      Icons.location_on_outlined,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.w,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w),
                      child: Text(
                        'Must be enter complete address with city name!',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    _buildText('Upload Document'),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      child: DottedBorder(
                        color: Colors.grey.shade300,
                        dashPattern: const [6, 4],
                        borderType: BorderType.Rect,
                        radius: Radius.circular(12),
                        child: InkWell(
                          onTap: controller.pickImage,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          child: Container(
                            height: 110,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: controller.selectedImage != null
                                ? Image.file(controller.selectedImage!,
                                    fit: BoxFit.cover)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.attach_file,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Upload Doctor Slip",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildText('Note'),
                    SizedBox(
                      height: 1.h,
                    ),
                    CustomTextField(
                      controller: controller.note,
                      label: 'Note',
                      hintText: 'Search Note',
                      validator: validateNote,
                      maxLines: 3,
                      mouseCursor: MouseCursor.defer,
                    ),
                    SizedBox(height: 2.h),
                    _buildText('Blood-Group'),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: DropdownButtonFormField<String>(
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select blood group'
                            : null,
                        value: controller.blood.text.isEmpty
                            ? null
                            : controller.blood.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: Colors.white,
                        decoration: customDecoration(
                            hint: "Select Blood Group",
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                        items: controller.bloodGroups
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.blood.text = value;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    _buildText('Patient Case'),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedValue.isEmpty
                            ? null
                            : controller.selectedValue,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: Colors.white,
                        decoration: customDecoration(
                            hint: "Select Your Patient Case",
                            hintStyle: TextStyle(
                                color: Colors.black12, fontSize: 10.sp)),
                        items: controller.patientCase
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedValue = value!;
                          controller.update();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          side: BorderSide(color: Colors.black45),
                          value: controller.isEmergencyHelp,
                          checkColor: Colors.white,
                          focusColor: Colors.red,
                          activeColor: Colors.red,

                          // Check if ttype is 'donor'
                          onChanged: (bool? value) {
                            controller.isEmergencyHelp = value!;

                            controller.update();
                          },
                        ),
                        Expanded(
                          child: Text(
                            'By clicking, you are allowing access to Emergency Help.',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          side: BorderSide(color: Colors.black45),
                          value: controller.isTerm,
                          checkColor: Colors.white,
                          focusColor: Colors.red,
                          activeColor: Colors.red,

                          // Check if ttype is 'donor'
                          onChanged: (bool? value) {
                            controller.isTerm = value!;

                            controller.update();
                          },
                        ),
                        Expanded(
                          child: Text(
                            'By clicking, you agree to our terms and codition',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        if (controller.hospital.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "must be enter hospital name",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        logSuccess(controller.selectedBlood);
                        if (controller.selectedBlood.toString().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "please select the blood type",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        if (controller.location.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "please enter the address",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        final image = controller.selectedImage;

                        if (image == null || image.path.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please select image",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }

                        if (controller.note.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "please enter the notes",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        if (controller.blood.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "please enter the blood group",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        if (controller.selectedValue.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "please select the patient case",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );
                          return;
                        }
                        if (!controller.isTerm) {
                          Get.snackbar(
                            "Error",
                            "please check the Terms and Conditions",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        await controller
                            .getUserList(controller.blood.text.trim());
                        await controller.getUserLocationList();

                        Map<String, dynamic> payload = {
                          'taker_id': UserController.to.userModel!.id,
                          'email': UserController.to.userModel!.email,
                          'name':
                              '${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname}',
                          'number': UserController.to.userModel!.phonenumber,
                          'image': UserController.to.userModel!.image,
                          'hospitalname': controller.hospital.text.trim(),
                          'blood_type': controller.selectedBlood.toString(),
                          'date': controller.selectedDate
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                          'time': controller.selectedTime.format(context),
                          'location': controller.location.text.trim(),
                          'unit': "1",
                          'note': controller.note.text.trim(),
                          'blood': controller.blood.text.trim(),
                          'situation': controller.selectedValue,
                          'blood_image': controller.selectedImage!.path,
                          'rating': '0.0',
                          'emergency_help': controller.isEmergencyHelp,
                          'status': false,
                        };
                        final mapController = PostRequestController.to;

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return MapRequestScreen(
                                payload: payload,
                                controller: mapController.controller,
                                userList: controller.userList,
                                userLocationList: controller.filteredList,
                                imageList: controller.imageList,
                              );
                            },
                            transitionDuration:
                                const Duration(microseconds: 100),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                                  Offset(10.0, 0.0); // slide in from the right
                              const end = Offset.zero;
                              const curve = Curves.easeInOutQuart;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 6.h,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: PRIMARY_COLOR),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Send Request',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget _buildText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}
