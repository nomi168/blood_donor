import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/edit_profile_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel model;

  const EditProfileScreen({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<EditProfileController>(
            init: EditProfileController(payload: model),
            builder: (controller) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 0.h),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera,
                                color: Colors.black45,
                                size: 30,
                              ),
                              onPressed: () {
                                controller.getImage(ImageSource.camera);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0),
                            child: Text(
                              'Camera',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 3.h, 0, 0),
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            // ignore: unnecessary_null_comparison
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : NetworkImage(model.image)
                                    as ImageProvider<Object>?,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.browse_gallery_sharp,
                                color: Colors.black45,
                                size: 30,
                              ),
                              onPressed: () {
                                controller.getImage(ImageSource.gallery);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                    child: Material(
                      elevation: 2.5,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: TextFormField(
                        controller: controller.fname,
                        decoration: InputDecoration(
                          label: const Text(
                            'First Name',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          // hintText: 'First Name',
                        ),
                        validator: validateFirstName,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
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
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
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
                                color:
                                    Colors.white), // Border color when focused
                          ),
                          // hintText: 'Last Name',
                        ),
                        validator: validateLastName,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
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
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
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
                                color:
                                    Colors.white), // Border color when focused
                          ),
                          // hintText: 'Location',
                        ),
                        validator: validateLocation,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
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
                          items: controller.bloodGroup
                              .map((e) => DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          validator: validateBlood,
                          onChanged: (v) {
                            controller.selectedBloodGroup = v!;
                            controller.update();
                          },
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.fname.text.isEmpty) {
                          showCustomSnackBar(
                              context, 'please enter first name', false);
                          return;
                        }
                        if (controller.lname.text.isEmpty) {
                          showCustomSnackBar(
                              context, 'please enter last name', false);
                          return;
                        }
                        if (controller.location.text.isEmpty) {
                          showCustomSnackBar(
                              context, 'please enter location', false);
                          return;
                        }
                        if (controller.selectedBloodGroup == null ||
                            controller.selectedBloodGroup.trim().isEmpty) {
                          showCustomSnackBar(
                              context, 'Please select a blood group.', false);
                          return;
                        }


                        Map<String, dynamic> payload = {
                          'firstname': controller.fname.text.trim(),
                          'lastname': controller.lname.text.trim(),
                          'location': controller.location.text.trim(),
                          'blood': controller.selectedBloodGroup,
                          'image': controller.image == null ||
                                  controller.image!.path.isEmpty
                              ? model.image
                              : controller.image!.path,
                        };

                        bool result = await controller.updateProfile(payload);
                        if (result) {
                          showCustomSnackBar(
                              context, 'update profile successfully', true);

                          UserController.to.userModel == null;
                          UserController.to.update();
                          UserController.to.onInit();

                          Get.offAll(() => Dashboard());
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          // ignore: prefer_const_constructors
                          EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFDE0A1E)), // Change button color
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }
}
