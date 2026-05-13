import 'package:blood_donor/core/constants.dart';

import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/blood_request_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class BloodRequestScreen extends StatelessWidget {
  const BloodRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<BloodRequestController>(
        init: BloodRequestController(),
        builder: (controller) {
          return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              color: PRIMARY_COLOR,
              onRefresh: () async {
                await controller.getTakerRefreshData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    controller.takerList.isEmpty && !controller.isLoading
                        ? Center(
                            child: Text(
                              "No data found",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(10, 0.w, 10, 0),
                            width: double.infinity,
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.isLoading
                                  ? 6
                                  : controller.takerList.length,
                              itemBuilder: (context, index) {
                                if (controller.isLoading) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 180,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  FeedTakerModel taker =
                                      controller.takerList[index];

                                  return Column(children: [
                                    Stack(
                                      children: [
                                        // Make the entire card non-clickable when expired
                                        AbsorbPointer(
                                          absorbing: taker.status ==
                                              true, // true => block interactions
                                          child: ColorFiltered(
                                            // Apply grayscale if expired, otherwise pass-through
                                            colorFilter: taker.status == true
                                                ? const ColorFilter
                                                    .matrix(<double>[
                                                    0.2126, 0.7152, 0.0722, 0,
                                                    0, // red
                                                    0.2126, 0.7152, 0.0722, 0,
                                                    0, // green
                                                    0.2126, 0.7152, 0.0722, 0,
                                                    0, // blue
                                                    0, 0, 0, 1, 0, // alpha
                                                  ])
                                                : const ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.multiply),
                                            child: Opacity(
                                              // optionally dim a bit if expired
                                              opacity: taker.status == true
                                                  ? 0.85
                                                  : 1.0,
                                              child: Container(
                                                width: double.infinity,
                                                height: 250,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, // Optional: Background color
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: const Color(
                                                          0xFFDDDDDD)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.1),
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      0, 3),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: 70,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl: taker.image !=
                                                                            null &&
                                                                        taker
                                                                            .image!
                                                                            .isNotEmpty
                                                                    ? taker
                                                                        .image!
                                                                    : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Container(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  taker.name ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      CupertinoIcons
                                                                          .calendar,
                                                                      size: 15,
                                                                      color: Colors
                                                                          .black45,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      DateFormat(
                                                                              'dd-MM-yyyy')
                                                                          .format(
                                                                              DateTime.parse(taker.date!)),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.black45),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      CupertinoIcons
                                                                          .clock,
                                                                      size: 15,
                                                                      color: Colors
                                                                          .black45,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      taker.time ??
                                                                          '',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.black45),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Spacer(),
                                                          InkWell(
                                                            splashFactory: NoSplash
                                                                .splashFactory,
                                                            splashColor: Colors
                                                                .transparent,
                                                            onTap: taker.status ==
                                                                    true
                                                                ? null // disabled when expired
                                                                : () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext context) => _buildAnimatedPopup(
                                                                          context,
                                                                          taker.note ??
                                                                              ''),
                                                                    );
                                                                  },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 30),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              PRIMARY_COLOR)),
                                                              child: Icon(
                                                                Icons.info,
                                                                color:
                                                                    taker.status ==
                                                                            true
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Divider(
                                                        height: 0.5,
                                                        color: Colors.black45,
                                                        thickness: 0.5),
                                                    const SizedBox(height: 5),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withValues(
                                                                        alpha:
                                                                            0.1),
                                                                spreadRadius: 2,
                                                                blurRadius: 5,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                                Icons.pin_drop,
                                                                color: Colors
                                                                    .black54),
                                                            const SizedBox(
                                                                width: 5),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                    'Location',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black54)),
                                                                Text(
                                                                  taker.location !=
                                                                          null
                                                                      ? (taker.location!.length >
                                                                              20
                                                                          ? '${taker.location!.substring(0, 20)}...'
                                                                          : taker
                                                                              .location!)
                                                                      : '',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  'blood-type: ${taker.blood ?? ''}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                  color: taker.situation ==
                                                                          'critical'
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: Text(
                                                                taker.situation ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        splashFactory: NoSplash
                                                            .splashFactory,
                                                        onTap: taker.status ==
                                                                true
                                                            ? null // disable delete when expired (or you can allow)
                                                            : () async {
                                                                final confirm =
                                                                    await showDialog<
                                                                        bool>(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false, // prevent closing by tapping outside
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                      elevation:
                                                                          5,
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.warning_amber_rounded,
                                                                              color: Colors.redAccent,
                                                                              size: 50,
                                                                            ),
                                                                            const SizedBox(height: 15),
                                                                            const Text(
                                                                              'Delete Blood Request?',
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 10),
                                                                            const Text(
                                                                              'Are you sure you want to delete this blood request? This action cannot be undone.',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 25),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                // Cancel Button
                                                                                TextButton(
                                                                                  style: TextButton.styleFrom(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      side: const BorderSide(color: Colors.grey),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context, false);
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(
                                                                                      fontSize: 15,
                                                                                      color: Colors.black87,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                // Delete Button
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.redAccent,
                                                                                    foregroundColor: Colors.white,
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () => Navigator.pop(context, true),
                                                                                  child: const Text(
                                                                                    'Delete',
                                                                                    style: TextStyle(fontSize: 15),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );

                                                                if (confirm ==
                                                                    true) {
                                                                  bool result =
                                                                      await controller
                                                                          .deleteBloodRequest(
                                                                              true);
                                                                  if (result) {
                                                                    Get.snackbar(
                                                                      "Success",
                                                                      "Blood request deleted successfully",
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                      snackStyle:
                                                                          SnackStyle
                                                                              .FLOATING,
                                                                      backgroundColor: Colors
                                                                          .green
                                                                          .withValues(
                                                                              alpha: 0.9),
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              10),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                      borderRadius:
                                                                          8,
                                                                      icon: Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              Colors.white),
                                                                    );
                                                                    controller
                                                                        .getTakerData();
                                                                    controller
                                                                        .update();
                                                                  } else {
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "There is a system problem. Please try again after a few seconds.",
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                      snackStyle:
                                                                          SnackStyle
                                                                              .FLOATING,
                                                                      backgroundColor: Colors
                                                                          .red
                                                                          .withValues(
                                                                              alpha: 0.9),
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              3),
                                                                      borderRadius:
                                                                          8,
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.white),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                        child: Container(
                                                          height: 40,
                                                          width: 140,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: taker.status ==
                                                                    true
                                                                ? Colors.grey
                                                                    .shade600
                                                                : Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              color: taker.status ==
                                                                      true
                                                                  ? Colors.grey
                                                                      .shade600
                                                                  : Colors
                                                                      .green,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Delete Request',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: taker.status ==
                                                                        true
                                                                    ? Colors
                                                                        .white70
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Watermark overlay when expired
                                        if (taker.status == true)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              // allow touches to pass to AbsorbPointer/ColorFiltered logic above (we already block taps)
                                              ignoring: true,
                                              child: Center(
                                                child: Transform.rotate(
                                                  angle:
                                                      -0.5, // radians; rotate watermark slightly
                                                  child: Opacity(
                                                    opacity: 0.15,
                                                    child: Text(
                                                      'EXPIRED',
                                                      style: TextStyle(
                                                        fontSize: 60,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        letterSpacing: 6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]);
                                }
                              },
                            ))
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget _buildAnimatedPopup(BuildContext context, String note) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              note,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
