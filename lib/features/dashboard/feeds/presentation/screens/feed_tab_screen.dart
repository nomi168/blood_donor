import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/feed_tab_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/chat_request_screen.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FeedScreen extends StatefulWidget {
  final String id;
  const FeedScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      logSuccess("My State is $state");
      UserController.to.updateAppStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      logSuccess("My State is $state");
      UserController.to.updateAppStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFFFFF),
      body: GetBuilder<FeedTabController>(
        init: FeedTabController(),
        builder: (controller) {
          return Column(
            children: [
              UserController.to.userModel!.type == 'taker'
                  ? Row(
                      children: [
                        Expanded(
                          child: Material(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 7,
                                  shadowColor: const Color(0x00e3e3e3),
                                  backgroundColor: controller.index == 1
                                      ? const Color(0xFFDE0A1E)
                                      : const Color(0xFFFFFFFF),
                                  minimumSize: Size(double.infinity, 6.h),
                                ),
                                child: Text(
                                  'Request',
                                  style: TextStyle(
                                    color: controller.index == 1
                                        ? const Color(0xFFFFFFFF)
                                        : const Color(0xFF353535),
                                  ),
                                ),
                                onPressed: () {
                                  // Optionally switch tabs for taker
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Material(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5.w, 5.h, 0, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 7,
                                  shadowColor: const Color(0x00e3e3e3),
                                  backgroundColor: controller.index == 1
                                      ? const Color(0xFFDE0A1E)
                                      : Colors.grey.shade300,
                                  minimumSize: Size(double.infinity, 6.h),
                                ),
                                child: Text(
                                  'Feed',
                                  style: TextStyle(
                                    color: controller.index == 1
                                        ? const Color(0xFFFFFFFF)
                                        : const Color(0xFF353535),
                                  ),
                                ),
                                onPressed: () {
                                  controller.index = 1;
                                  controller.update();
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(1.w, 5.h, 5.w, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 7,
                                  shadowColor: const Color(0x00e3e3e3),
                                  backgroundColor: controller.index == 2
                                      ? const Color(0xFFDE0A1E)
                                      : Colors.grey.shade300,
                                  minimumSize: Size(double.infinity, 6.h),
                                ),
                                child: Text(
                                  'Request',
                                  style: TextStyle(
                                    color: controller.index == 2
                                        ? const Color(0xFFFFFFFF)
                                        : const Color(0xFF353535),
                                  ),
                                ),
                                onPressed: () {
                                  controller.index = 2;
                                  controller.update();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              UserController.to.userModel!.type == 'taker'
                  ? Expanded(child: ChatRequestScreen())
                  : Expanded(
                      child: controller.index == 1
                          ? FeedsScreen()
                          : controller.index == 2
                              ? ChatRequestScreen()
                              : Container(),
                    ),
            ],
          );
        },
      ),
    );
  }
}
