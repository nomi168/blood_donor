// ignore_for_file: file_names

import 'package:blood_donor/features/dashboard/menus/presentation/screens/Invite_screen.dart';
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Bar with back + title
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 26,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Referral Invitation',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 48), // balance with back button
            ],
          ),

          const SizedBox(height: 20),

          // Image Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'images/image1.jpeg',
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
          ),

          const SizedBox(height: 20),

          // App Link Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: TextEditingController(text: appLink),
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'App Link',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: appLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('App link copied to clipboard!',
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Share Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                InkWell(
                onTap: (){
                   Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const InviteScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart)),
                          child: child,
                        );
                      },
                    ));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.orange.withValues(alpha: .1),
                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/previews/053/687/866/non_2x/invitation-letter-icon-concept-of-receiving-important-message-or-notification-free-vector.jpg',
                          height: 34,
                          width: 34,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              // WhatsApp Button
              InkWell(
                onTap: _launchWhatsApp,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green.withValues(alpha: .1),
                        child: Image.network(
                          'https://cdn-icons-png.freepik.com/256/15707/15707917.png',
                          height: 34,
                          width: 34,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'WhatsApp',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 30),

              // Email Button
              InkWell(
                onTap: _launchEmail,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.withValues(alpha: .1),
                        child: const Icon(Icons.email,
                            size: 30, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
