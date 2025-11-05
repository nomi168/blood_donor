import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/blood_bank_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_banks_update/blood_donate_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BloodBankScreen extends StatelessWidget {
  const BloodBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BloodBankController>(
      init: BloodBankController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 22,
                            color: Colors.black87,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Spacer(),
                        Text(
                          'Blood Bank',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.search, color: Colors.red.shade400),
                          hintText: 'Search Blood Bank',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (value) {
                          controller.filterUsers(value);
                        },
                      ),
                    ),
                  ),
                  controller.isLoading && controller.bloodBankList.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                color: PRIMARY_COLOR,
                                strokeWidth: 3,
                              ),
                            ),
                          ],
                        )
                      : !controller.isLoading &&
                              controller.bloodBankList.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 40.h,
                                ),
                                Center(
                                  child: Text(
                                    'no data found',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: controller.filterList == null ||
                                        controller.filterList!.isEmpty
                                    ? controller.bloodBankList.length
                                    : controller.filterList!.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                itemBuilder: (context, index) {
                                  BloodBank list =
                                      controller.filterList == null ||
                                              controller.filterList!.isEmpty
                                          ? controller.bloodBankList[index]
                                          : controller.filterList![index];

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// Name + Location Row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  list.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Icon(
                                                CupertinoIcons.heart_fill,
                                                color: Colors.red.shade400,
                                                size: 20,
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.location_solid,
                                                size: 16,
                                                color: Colors.blue.shade400,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  '${list.address}, ${list.city}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          /// Contact info
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.mail_solid,
                                                  size: 16,
                                                  color: Colors.grey.shade600),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  list.email,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.phone_solid,
                                                  size: 16,
                                                  color: Colors.green.shade600),
                                              const SizedBox(width: 6),
                                              Text(
                                                list.contactNo,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          /// Blood Availability Section
                                          const Text(
                                            "Accepted Blood Groups",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: controller.bloodGroups
                                                .map((group) {
                                              return ChoiceChip(
                                                label: Text(
                                                  group,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: controller
                                                                .selectedGroup ==
                                                            group
                                                        ? Colors.white
                                                        : Colors.green.shade900,
                                                  ),
                                                ),
                                                selected:
                                                    controller.selectedGroup ==
                                                        group,
                                                selectedColor: Colors.green,
                                                backgroundColor:
                                                    Colors.green.shade100,
                                                onSelected: (selected) {
                                                  controller.selectedGroup =
                                                      selected ? group : null;
                                                  controller.update();
                                                },
                                              );
                                            }).toList(),
                                          ),
                                          const SizedBox(height: 12),

                                          // Action buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Location button
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  controller.showLocationPopup(
                                                      context, list.address);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue.shade50,
                                                  foregroundColor: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                icon: const Icon(
                                                    CupertinoIcons.location,
                                                    size: 18),
                                                label: const Text("Location"),
                                              ),

                                              const SizedBox(width: 10),

                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  if (controller
                                                          .selectedGroup !=
                                                      null) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BloodDonateScreen(
                                                                  bloodModel:
                                                                      list,
                                                                  selectedBloodType:
                                                                      controller
                                                                          .selectedGroup!,
                                                                )));
                                                  } else {
                                                    Get.snackbar(
                                                      "Error",
                                                      "Please select a blood group first",
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                      snackStyle:
                                                          SnackStyle.FLOATING,
                                                      backgroundColor:
                                                          Colors.red.withValues(
                                                              alpha: 0.9),
                                                      colorText: Colors.white,
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      duration:
                                                          Duration(seconds: 3),
                                                      borderRadius: 8,
                                                      icon: Icon(Icons.error,
                                                          color: Colors.white),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red.shade50,
                                                  foregroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                icon: Icon(Icons.bloodtype,
                                                    color: Colors.red.shade200,
                                                    size: 18),
                                                label: const Text("Blood"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ));
      },
    );
  }
}
