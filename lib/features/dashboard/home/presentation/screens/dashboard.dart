import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/user_swticher.dart';
import 'package:blood_donor/features/dashboard/chat/presentation/screens/chat_screen.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/feed_tab_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/home_screen.dart';
import 'package:blood_donor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final AccountRepository _accountRepository = AccountRepository();
  String selectedOption = '';
  bool checkExistDonor = false;
  final PageController _pageController = PageController(initialPage: 2);
  int _selectedIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [
    const FeedScreen(id: '12456'),
    const ChatScreen(),
    const HomeScreen(),
    const AccountScreen(),
    const UserSwitcherScreen()
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    justOnlyFindTaker();

    //  onInitData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  Future<void> justOnlyFindTaker() async {
    bool result =
        await checkingDonorSwitcher(UserController.to.userModel!.email);
    if (result == true) {
      checkExistDonor = true;
    }
    if (UserController.to.userModel!.type == 'taker' &&
        checkExistDonor == false) {
      selectedOption = 'taker';
      setState(() {});
    }
    getLocationPermission();
  }

  Future<void> onInitData() async {
    bool result =
        await checkingDonorSwitcher(UserController.to.userModel!.email);
    if (result == true) {
      checkExistDonor = true;
    }
    if (UserController.to.userModel!.type == 'donor' &&
        UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'donor' &&
        !UserController.to.userModel!.status &&
        !checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'donor' &&
        !UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'taker' &&
        UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'taker';
    } else if (UserController.to.userModel!.type == 'taker' &&
        !UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'taker';
    } else if (UserController.to.userModel!.type == 'taker' &&
        !UserController.to.userModel!.status &&
        checkExistDonor == false) {
      selectedOption = 'taker';
    }
    setState(() {});

    showPopup(navigatorKey.currentContext!);
  }

  Future<void> getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void navigateToChatTab() {
    setState(() => _selectedIndex = 1);
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToFeedTab() {
    setState(() => _selectedIndex = 0);
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 2) {
          setState(() => _selectedIndex = 2);
          _pageController.jumpToPage(2);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        floatingActionButton: selectedOption != 'taker'
    ? ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () => _onItemTapped(4),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 
                        0.15 +
                            (_animationController.value * 0.25),
                      ),
                      blurRadius:
                          10 + (_animationController.value * 15),
                      spreadRadius:
                          1 + (_animationController.value * 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'images/svg/Logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      )
    : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.grey,
          shadowColor: Colors.black26,
          color: Colors.white,
          shape: selectedOption != 'taker'
              ? const CircularNotchedRectangle()
              : null,
          notchMargin: 8,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  icon: Icons.bloodtype_rounded,
                  label: "Feed",
                  index: 0,
                ),
                _navItem(
                  icon: CupertinoIcons.home,
                  label: "Home",
                  index: 2,
                ),
                if (selectedOption != 'taker') const SizedBox(width: 60),
                _navItem(
                  icon: CupertinoIcons.chat_bubble,
                  label: "Chat",
                  index: 1,
                ),
                _navItem(
                  icon: CupertinoIcons.person,
                  label: "Account",
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? PRIMARY_COLOR : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? PRIMARY_COLOR : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void showPopup(BuildContext context) {
    if (UserController.to.userModel!.type == "taker" && checkExistDonor) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.swap_horiz, color: Colors.blue, size: 26),
              SizedBox(width: 8),
              Text(
                "Switch Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You are currently a Donor. You can switch your role below:",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // ✅ Your custom toggle bar goes here
              UserController.to.userModel!.type == 'donor' ||
                      checkExistDonor == true
                  ? Container(
                      height: 50, // replace with 6.h if using Sizer
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔴 Taker Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'taker') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Taker",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .9),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'taker';
                                setState(() {});

                                bool? response = await addingDonorSwitcher(
                                    UserController.to.userModel!.email);

                                if (response == true) {
                                  bool? result = await updateUserType('taker',
                                      UserController.to.userModel!.email);

                                  if (result == true) {
                                    Restart.restartApp();
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Could not update user. Please try again.",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.red.withValues(alpha: .8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      duration: const Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to create donor switcher. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w if using Sizer
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'taker'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Taker',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'taker'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'donor') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Donor",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .8),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'donor';
                                setState(() {});

                                bool? result = await updateUserType('donor',
                                    UserController.to.userModel!.email);

                                if (result == true) {
                                  Restart.restartApp();
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Could not update user. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'donor'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Donor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'donor'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    } else if (UserController.to.userModel!.type == "taker" &&
        !checkExistDonor) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.red, size: 26),
              SizedBox(width: 8),
              Text(
                "Notice",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            "Takers will not be able to donate any blood.",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (UserController.to.userModel!.type == "donor") {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.swap_horiz, color: Colors.blue, size: 26),
              SizedBox(width: 8),
              Text(
                "Switch Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You are currently a Donor. You can switch your role below:",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // ✅ Your custom toggle bar goes here
              UserController.to.userModel!.type == 'donor' ||
                      checkExistDonor == true
                  ? Container(
                      height: 50, // replace with 6.h if using Sizer
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔴 Taker Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'taker') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Taker",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .9),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'taker';
                                setState(() {});

                                bool? response = await addingDonorSwitcher(
                                    UserController.to.userModel!.email);

                                if (response == true) {
                                  bool? result = await updateUserType('taker',
                                      UserController.to.userModel!.email);

                                  if (result == true) {
                                    Restart.restartApp();
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Could not update user. Please try again.",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.red.withValues(alpha: .8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      duration: const Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to create donor switcher. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w if using Sizer
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'taker'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Taker',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'taker'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // 🔵 Donor Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'donor') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Donor",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .8),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'donor';
                                setState(() {});

                                bool? result = await updateUserType('donor',
                                    UserController.to.userModel!.email);

                                if (result == true) {
                                  Restart.restartApp();
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Could not update user. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'donor'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Donor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'donor'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> checkingDonorSwitcher(String email) async {
    try {
      return await _accountRepository.checkingDonorSwitcher(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking donor switcher!');
      return false;
    }
  }

  Future<bool> addingDonorSwitcher(String email) async {
    try {
      showLoader('adding...');
      return await _accountRepository.addingDonorSwitcher(email);
    } catch (e) {
      Helper.handleError(e, 'Error while adding donor switcher!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> updateUserType(String userType, String email) async {
    try {
      showLoader('updating type...');
      return await _accountRepository.updateUserType(userType, email);
    } catch (e) {
      Helper.handleError(e, 'Error while updating user type!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  Color getColor(int index) {
    return selectedIndex == index ? const Color(0xffE50928) : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _item(
              icon: CupertinoIcons.chat_bubble_text,
              label: "Chat",
              index: 1,
            ),
          ),
          Expanded(
            child: _item(
              icon: Icons.assignment_outlined,
              label: "Request",
              index: 0,
            ),
          ),
          const SizedBox(width: 90),
          Expanded(
            child: _item(
              icon: CupertinoIcons.bell,
              label: "Notification",
              index: 3,
            ),
          ),
          Expanded(
            child: _item(
              icon: CupertinoIcons.person,
              label: "Profile",
              index: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: getColor(index),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: getColor(index),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
