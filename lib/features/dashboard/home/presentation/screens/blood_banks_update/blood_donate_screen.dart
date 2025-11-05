import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/blood_donate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BloodDonateScreen extends StatelessWidget {
  final BloodBank bloodModel;
  final String selectedBloodType;
  const BloodDonateScreen(
      {super.key, required this.bloodModel, required this.selectedBloodType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<BloodDonateController>(
        init: BloodDonateController(
            bankModel: bloodModel, selectedBloodType: selectedBloodType),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Top AppBar Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: Colors.black54,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Blood Donation Form',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // keeps title centered
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        _buildInputField(
                            label: "Donor Name",
                            icon: Icons.person,
                            controller: controller.donorName,
                            istrue: false),
                        _buildInputField(
                            label: "Donor Email",
                            icon: Icons.email,
                            controller: controller.donorEmail,
                            istrue: true),
                        _buildInputField(
                            label: "Donor Number",
                            icon: Icons.phone,
                            controller: controller.donorNumber,
                            istrue: false),
                        _buildInputField(
                            label: "Donor Address",
                            icon: Icons.home,
                            controller: controller.donorAddress,
                            istrue: false),
                        _buildInputField(
                            label: "Donor Blood Group",
                            icon: Icons.bloodtype,
                            controller: controller.donorbloodGroup,
                            istrue: true),
                        _buildInputField(
                            label: "Blood Bank Name",
                            icon: Icons.local_hospital,
                            controller: controller.bankName,
                            istrue: true),
                        _buildInputField(
                            label: "Blood Bank Email",
                            icon: Icons.email_outlined,
                            controller: controller.bankEmail,
                            istrue: true),
                        _buildInputField(
                            label: "Blood Bank Address",
                            icon: Icons.location_on,
                            controller: controller.bankAddress,
                            istrue: true),
                        _buildInputField(
                            label: "Selected Blood",
                            icon: Icons.bloodtype_outlined,
                            controller: controller.selectedBlood,
                            istrue: false),

                        const SizedBox(height: 20),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.donorName.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Donor Name is required",
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
                              if (controller.donorEmail.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Donor Email is required",
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
                              if (controller.donorNumber.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Donor Number is required",
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
                              if (controller.donorAddress.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Donor ADdress is required",
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
                              if (controller.donorbloodGroup.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Donor Blood is required",
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
                              if (controller.bankName.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Blood Bank Name is required",
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
                              if (controller.bankEmail.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Blood Bank Email is required",
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
                              if (controller.bankAddress.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Blood Bank Address is required",
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
                              if (controller.selectedBlood.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Blood is required",
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
                                'donor_name': controller.donorName.text.trim(),
                                'donor_email':
                                    controller.donorEmail.text.trim(),
                                'donor_number':
                                    controller.donorNumber.text.trim(),
                                'donor_address':
                                    controller.donorAddress.text.trim(),
                                'donor_blood':
                                    controller.donorbloodGroup.text.trim(),
                                'bank_name': controller.bankName.text.trim(),
                                'bank_email': controller.bankEmail.text.trim(),
                                'bank_address':
                                    controller.bankAddress.text.trim(),
                                'selected_blood':
                                    controller.selectedBlood.text.trim(),
                                'createdAt': DateTime.now().toIso8601String(),
                                'status': ''
                              };
                              bool response =
                                  await controller.sendEmail(payload);
                              if (response) {
                                bool result =
                                    await controller.addBloodBankDonor(payload);
                                if (result) {
                                  Get.snackbar(
                                    "Success",
                                    "Blood donation submitted successfully!",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor:
                                        Colors.green.withValues(alpha: 0.9),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    borderRadius: 8,
                                    duration: const Duration(seconds: 3),
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.white),
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Error while adding blood donation, please try again",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: 0.9),
                                    colorText: Colors.white,
                                    margin: EdgeInsets.all(10),
                                    duration: Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon:
                                        Icon(Icons.error, color: Colors.white),
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Error while sending email to blood bank, please try again",
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Custom TextField Widget for cleaner code
  Widget _buildInputField(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      required bool istrue}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(10.0),
        child: TextFormField(
          readOnly: istrue,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: Icon(icon, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
