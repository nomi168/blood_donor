import 'dart:math';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:blood_donor/Screens/Main%20Screen/Chat%20Screen/ChatProfile.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/HomeScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/FeedScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/MenuScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/AccountScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _pageController = PageController(initialPage: 2);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 2);

  int maxCount = 5;

  @override
  void initState() {
    getLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const FeedScreen(id: '12456'),
    const ChatProfile(),
    const HomeScreen(),
    const AccountScreen(),
    const MenuScreen(),
  ];

  Future<void> getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Error: Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Error: Location permission permanently denied");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_controller.index != 2) {
          setState(() {
            _controller.index = 2;
          });
          _pageController.jumpToPage(2);
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: Colors.white,
                showLabel: false,
                shadowElevation: 5,
                kBottomRadius: 8.0,
                notchShader: const SweepGradient(
                  startAngle: 0,
                  endAngle: pi / 2,
                  colors: [Color(0xFFDE0A1E), Colors.red],
                  tileMode: TileMode.mirror,
                ).createShader(
                    Rect.fromCircle(center: Offset.zero, radius: 8.0)),
                notchColor: Colors.black87,

                /// restart app if you change removeMargins
                removeMargins: false,
                bottomBarWidth: 500,
                durationInMilliSeconds: 300,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.feed,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.feed,
                      color: Colors.white,
                    ),
                    itemLabel: 'Page 1',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.chat_bubble,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                    ),
                    itemLabel: 'Page 2',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    itemLabel: 'Page 3',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    itemLabel: 'Page 4',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.menu,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    itemLabel: 'Page 5',
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24.0,
              )
            : null,
      ),
    );
  }
}
