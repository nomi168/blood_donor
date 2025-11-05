// ignore_for_file: file_names

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/dashboard/account/data/models/voucher_model.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/voucher_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<VoucherController>(
          init: VoucherController(),
          builder: (controller) {
            return Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const AccountScreen();
                            },
                            transitionDuration:
                                const Duration(microseconds: 100),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                                  Offset(-10.0, 0.0); // slide in from the left
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
                    ),
                    Spacer(),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Vouchers',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    controller.voucherList.isEmpty &&
                            controller.isLoading == false
                        ? Center(
                            child: Text('no data found'),
                          )
                        : controller.voucherList.isEmpty &&
                                controller.isLoading == true
                            ? Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  CircularProgressIndicator(
                                    color: PRIMARY_COLOR,
                                    strokeWidth: 3,
                                  ),
                                ],
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ListView.builder(
                                    itemCount: controller.voucherList.length,
                                    itemBuilder: (context, index) {
                                      VoucherModel voucher =
                                          controller.voucherList[index];

                                      return TweenAnimationBuilder(
                                        duration: Duration(
                                            milliseconds: 400 + (index * 100)),
                                        curve: Curves.easeOut,
                                        tween: Tween<double>(begin: 0, end: 1),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(0, (1 - value) * 20),
                                            child: Opacity(
                                                opacity: value, child: child),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 
                                                    0.2),
                                                blurRadius: 12, 
                                                spreadRadius:
                                                    2, 
                                                offset: Offset(0,
                                                    0), 
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Top row with image + info
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        width: 70,
                                                        height: 70,
                                                        imageUrl: voucher.image,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CupertinoActivityIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error,
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            voucher.name,
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            voucher.email,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Wrap(
                                                            children: [
                                                              Chip(
                                                                backgroundColor:
                                                                    Colors.red
                                                                        .shade50,
                                                                label: Text(
                                                                  "Blood: ${voucher.blood}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade700,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Chip(
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade50,
                                                                label: Text(
                                                                  "No. ${voucher.number}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue
                                                                          .shade700,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 10),

                                                // Voucher title
                                                Text(
                                                  voucher.title,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),

                                                const SizedBox(height: 5),

                                                // Description
                                                Text(
                                                  voucher.description,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),

                                                const SizedBox(height: 10),

                                                // Metadata
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 6,
                                                  children: [
                                                    _infoChip(
                                                        "Design: ${voucher.designName}"),
                                                    _infoChip(
                                                        "Start: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(voucher.startDate.toString()))}"),
                                                    _infoChip(
                                                        "End: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(voucher.endDate.toString()))}"),
                                                  ],
                                                ),

                                                const SizedBox(height: 10),

                                                // Voucher design PDF preview
                                                if (voucher
                                                    .designPath.isNotEmpty) ...[
                                                  Text(
                                                    "Voucher Design",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: SfPdfViewer.network(
                                                        voucher.designPath),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                  ],
                ),
              )
            ]);
          },
        ),
      ),
    );
  }

  // Helper widget for metadata chips
  Widget _infoChip(String text) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
