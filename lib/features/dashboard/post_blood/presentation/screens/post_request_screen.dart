import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/controllers/post_request_controller.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/screens/map_request_screen.dart';
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
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 2.w,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 27,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        Text(
                          'Post A Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                              color: Colors.black54),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0,
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          controller: controller.hospital,
                          decoration: InputDecoration(
                            label: const Text('Search Hospital'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            suffixIcon: const Icon(Icons.local_hospital),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Border color when focused
                            ),
                            hintText: 'Search Hospital',
                          ),
                          validator: validateHospital,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 13.0),
                          labelText: "Select Blood Type",
                          suffixIcon: Icon(Icons.bloodtype),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        items: controller.bloodType
                            .map((e) => DropdownMenuItem(
                                  // ignore: sort_child_properties_last
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (v) {
                          controller.selectedBlood = v!;
                          controller.update();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text:
                                          "${controller.selectedDate.toLocal()}"
                                              .split(' ')[0],
                                    ),
                                    decoration: InputDecoration(
                                      label: const Text('Select Date'),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                      hintText: 'Select Date',
                                    ),
                                    onTap: () => controller.selectDate(context),
                                  ),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      // ignore: unnecessary_string_interpolations
                                      text:
                                          "${controller.selectedTime.format(context)}",
                                    ),
                                    decoration: InputDecoration(
                                      label: const Text('Select Time'),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      suffixIcon: const Icon(Icons.access_time),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                      hintText: 'Select Time',
                                    ),
                                    onTap: () => controller.selectTime(context),
                                  ),
                                ))),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          controller: controller.location,
                          decoration: InputDecoration(
                            label: const Text('Address'),
                            hintText: 'Address',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            suffixIcon: IconButton(
                              icon: controller.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : Container(
                                      width: 120,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(06)),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.my_location,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Location',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                              onPressed: controller.isLoading
                                  ? null
                                  : controller.getCurrentAddress,
                            ),
                          ),
                          validator: validateAddress,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'Must be enter complete address with city name!',
                        style: TextStyle(fontSize: 11, color: PRIMARY_COLOR),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(06)),
                              height: 90,
                              child: controller.selectedImage != null
                                  ? Image.file(controller.selectedImage!,
                                      fit: BoxFit.cover)
                                  : const Center(child: Text('No Image')),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            onTap: controller.pickImage,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Select Doctor slip',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 5),
                    //   child: Material(
                    //     color: Colors.white,
                    //     elevation: 7.0, // Add shadow/elevation
                    //     borderRadius:
                    //         BorderRadius.circular(10.0), // Add border radius
                    //     child: TextFormField(
                    //       keyboardType: TextInputType.number,
                    //       controller: controller.unit,
                    //       decoration: InputDecoration(
                    //         label: const Text('Units'),
                    //         contentPadding: const EdgeInsets.symmetric(
                    //             horizontal: 16.0), // Adjust padding
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8.0),
                    //           borderSide: const BorderSide(
                    //               color: Colors.grey), // Border color
                    //         ),
                    //         suffixIcon: const Icon(Icons.bloodtype_sharp),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8.0),
                    //           borderSide: const BorderSide(
                    //               color:
                    //                   Colors.blue), // Border color when focused
                    //         ),
                    //         hintText: 'Unit',
                    //       ),
                    //       validator: validateAddress,
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        // ignore: sized_box_for_whitespace
                        child: TextFormField(
                          controller: controller.note,
                          maxLines: 3,
                          mouseCursor: MouseCursor.defer,
                          decoration: InputDecoration(
                            label: const Text('Note'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: const Icon(Icons.note),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Note',
                          ),
                          validator: validateNote,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            label: const Text('Blood Group'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            suffixIcon: const Icon(
                              Icons.bloodtype,
                              color: Color(0xFFDE0A1E),
                              size: 35.0,
                            ),
                          ),
                          hint: const Text('Select Blood Group'),
                          value: controller.blood.text.isEmpty
                              ? null
                              : controller.blood.text,
                          items: controller.bloodGroups.map((group) {
                            return DropdownMenuItem(
                              value: group,
                              child: Text(group),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.blood.text = value;
                            }
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select blood group'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Text(
                            'Critical',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: controller.isToggled
                                    ? PRIMARY_COLOR
                                    : Colors.black),
                          ),
                          Spacer(),
                          Switch(
                            value: controller.isToggled,
                            activeColor: Colors.red,
                            onChanged: (bool value) {
                              controller.isToggled = value;

                              if (value) {
                                controller.selectedValue = 'critical';
                              } else {
                                controller.selectedValue = 'normal';
                              }
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
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
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      children: [
                        Checkbox(
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
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
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

                        // if (controller.unit.text.isEmpty) {
                        //   Get.snackbar(
                        //     "Error",
                        //     "please enter the unit",
                        //     snackPosition: SnackPosition.TOP,
                        //     snackStyle: SnackStyle.FLOATING,
                        //     backgroundColor: Colors.red.withValues(alpha: 0.9),
                        //     colorText: Colors.white,
                        //     margin: EdgeInsets.all(10),
                        //     duration: Duration(seconds: 3),
                        //     borderRadius: 8,
                        //     icon: Icon(Icons.error, color: Colors.white),
                        //   );

                        //   return;
                        // }
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
                          ;

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
                                  userLocationList: controller.filteredList);
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
}
