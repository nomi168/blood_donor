// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/MenuScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../Provider/FirebaseAuth.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool eligibilityChecked = false;
  bool privacyPolicyChecked = false;
  bool donationProcessChecked = false;
  bool safetyChecked = false;
  bool hygieneChecked = false;
  bool eligibility = false;
  bool privacy_policy = false;
  bool donation_process = false;
  bool safety = false;
  bool hygience = false;

  @override
  void initState() {
    getTerms_Condition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 5.h, 0, 0),
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
                              return const MenuScreen();
                            },
                            transitionDuration: const Duration(seconds: 1),
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 5.h, 0, 0),
                    child: Text(
                      'Terms & Condition',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              buildCheckBoxRow('Eligibility', eligibility, (value) {
                // setState(() {
                //   // eligibilityChecked = value!;
                // });
              }),
              SizedBox(
                height: 15,
              ),
              buildCheckBoxRow('Privacy Policy', privacy_policy, (value) {
                // setState(() {
                //   privacyPolicyChecked = value!;
                // });
              }),
              SizedBox(
                height: 15,
              ),
              buildCheckBoxRow('Donation Process', donation_process, (value) {
                // setState(() {
                //   donationProcessChecked = value!;
                // });
              }),
              SizedBox(
                height: 15,
              ),
              buildCheckBoxRow('Safety', safety, (value) {
                // setState(() {
                //   safetyChecked = value!;
                // });
              }),
              SizedBox(
                height: 15,
              ),
              buildCheckBoxRow('Hygiene', hygience, (value) {
                // setState(() {
                //   hygieneChecked = value!;
                // });
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget buildCheckBoxRow(
      String title, bool isChecked, ValueChanged<bool?> onChanged) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0, // Top border width (optional)
            ),
            left: BorderSide(
              color: Colors.grey, // Red left border color
              width: 1.0, // Left border width (optional)
            ),
            right: BorderSide(
              color: Colors.grey, // Red right border color
              width: 1.0, // Right border width (optional)
            ),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0.h, 0, 0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
                child: CheckboxListTile(
                  activeColor: const Color(0xFFDE0A1E),
                  value: isChecked,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> getTerms_Condition() async {
    try {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      // Use the 'where' method to query documents with the specified email
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('user_uid') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('terms_condition')
          .where('user_id', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data

        bool eligible = userDoc['eligibility'];
        bool privacy = userDoc['privacy_policy'];
        bool donation = userDoc['donation_process'];
        bool saf = userDoc['safety'];
        bool hyg = userDoc['hygiene'];

        eligibility = eligible;
        privacy_policy = privacy;
        donation_process = donation;
        safety = saf;
        hygience = hyg;
        setState(() {});
        provider.notifyListeners();
      } else {
        // No user found with the specified email
        print('User not found with email: $userId');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
