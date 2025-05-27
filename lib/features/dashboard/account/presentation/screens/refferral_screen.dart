// ignore_for_file: file_names

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class RefferalInvitationScreen extends StatefulWidget {
  const RefferalInvitationScreen({super.key});

  @override
  State<RefferalInvitationScreen> createState() =>
      _RefferalInvitationScreenState();
}

class _RefferalInvitationScreenState extends State<RefferalInvitationScreen> {
  String appLink =
      'https://play.google.com/store/apps/details?id=com.pakistan.Ebloodpakistan&pcampaignid=web_share';

  Future<void> _launchWhatsApp() async {
    final whatsappUrl =
        'https://wa.me/?text=Check%20out%20this%20app:%20$appLink';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  Future<void> _launchEmail() async {
    final emailUrl = 'mailto:?subject=Check%20out%20this%20app&body=$appLink';
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(2.w, 0.h, 0, 0),
                  child: IconButton(
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
                          transitionDuration: const Duration(microseconds: 100),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0.h, 0, 0),
                child: Text(
                  'Refferal Iniviation',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset('images/image1.jpeg'),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: TextEditingController(text: appLink),
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'App Link',
                suffixIcon: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    // Copy app link to clipboard
                    Clipboard.setData(ClipboardData(text: appLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('App link copied to clipboard!'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _launchWhatsApp();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(08),
                      color: Colors.grey.withValues(alpha: 0.3)),
                  child: Column(
                    children: [
                      Image.network(
                          height: 40,
                          width: 40,
                          'https://cdn-icons-png.freepik.com/256/15707/15707917.png?semt=ais_hybrid'),
                      Text(
                        'Whatsapp',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: PRIMARY_COLOR),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  _launchEmail();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(08),
                      color: Colors.grey.withValues(alpha: 0.3)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.email,
                        size: 40,
                        color: Colors.blue,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: PRIMARY_COLOR),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
