import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/edit_profile_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    /// Profile Image Section
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          /// Profile Picture
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : NetworkImage(model.image)
                                    as ImageProvider<Object>?,
                          ),

                          /// + Icon Overlay
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                _showImagePicker(context, controller);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// First Name
                    _buildTextField(
                      controller: controller.fname,
                      label: "First Name",
                      validator: validateFirstName,
                    ),

                    /// Last Name
                    _buildTextField(
                      controller: controller.lname,
                      label: "Last Name",
                      validator: validateLastName,
                    ),

                    /// Location
                    _buildTextField(
                      controller: controller.location,
                      label: "Location",
                      validator: validateLocation,
                    ),

                    /// Blood Group Dropdown
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
                      child: Material(
                        elevation: 2.5,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                            labelText: "Blood Group",
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: controller.bloodGroup
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          validator: validateBlood,
                          onChanged: (v) {
                            controller.selectedBloodGroup = v!;
                            controller.update();
                          },
                        ),
                      ),
                    ),

                    /// Update Button
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.fname.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "please enter first name",
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

                            return;
                          }
                          if (controller.lname.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "please enter last name",
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

                            return;
                          }
                          if (controller.location.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "please enter location",
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

                            return;
                          }
                          if (controller.selectedBloodGroup == "" ||
                              controller.selectedBloodGroup.trim().isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please select a blood group.",
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

                            return;
                          }

                          Map<String, dynamic> payload = {
                            'firstname': controller.fname.text.trim(),
                            'lastname': controller.lname.text.trim(),
                            'location': controller.location.text.trim(),
                            'bloodgroup': controller.selectedBloodGroup,
                            'image': controller.image == null ||
                                    controller.image!.path.isEmpty
                                ? model.image
                                : controller.image!.path,
                          };

                          UserModel? result = await controller.updateProfile(payload);
                          if (result!=null) {
                            Get.snackbar(
                              "Success",
                              "update profile successfully",
                              snackPosition: SnackPosition.TOP,
                              snackStyle: SnackStyle.FLOATING,
                              backgroundColor:
                                  Colors.green.withValues(alpha: 0.9),
                              colorText: Colors.white,
                              margin: EdgeInsets.all(10),
                              duration: Duration(seconds: 3),
                              borderRadius: 8,
                              icon:
                                  Icon(Icons.check_circle, color: Colors.white),
                            );

                            UserController.to.userModel = result;
                            UserController.to.update();
                         
                            // UserController.to.onInit();

                            Get.offAll(() => Dashboard());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE0A1E),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

              /// Reusable TextField Widget
            },
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 2.2.h, 5.w, 0),
      child: Material(
        elevation: 2.5,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 15, color: Colors.black54),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context, controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, size: 30, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      controller.getImage(ImageSource.camera);
                    },
                  ),
                  Text("Camera",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.photo, size: 30, color: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                      controller.getImage(ImageSource.gallery);
                    },
                  ),
                  Text("Gallery",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
