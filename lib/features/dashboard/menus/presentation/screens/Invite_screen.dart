// ignore_for_file: file_names

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/controllers/invite_controller.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/menu_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<InviteController>(
        init: InviteController(),
        builder: (controller) {
          return Column(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(3.w, 0.h, 0, 0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 27,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const MenuSettingScreen();
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
                  ),
                ),
                Spacer(),
                Text(
                  'Invite',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  width: 50,
                ),
                Spacer()
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) => controller.filterContacts(value),
                decoration: InputDecoration(
                  hintText: 'Search Contacts',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: controller.filteredContacts.isEmpty &&
                      controller.isLoading == false
                  ? Center(child: Text('No contacts found'))
                  : controller.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                          color: PRIMARY_COLOR,
                          strokeWidth: 3,
                        ))
                      : ListView.builder(
                          itemCount: controller.filteredContacts.length,
                          itemBuilder: (context, index) {
                            Contact contact =
                                controller.filteredContacts[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6)),
                              child: ListTile(
                                title: Text(contact.displayName),
                                subtitle: Text(contact.phones.isNotEmpty
                                    ? contact.phones.first.number
                                    : 'No Phone Number'),
                                trailing: IconButton(
                                  icon: Icon(Icons.message),
                                  onPressed: contact.phones.isNotEmpty
                                      ? () => controller
                                          .sendSMS(contact.phones.first.number)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ]);
        },
      ),
    );
  }
}
