// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/MenuScreen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      _getAllContacts();
    }
  }

  Future<void> _getAllContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
      _filteredContacts = _contacts;
    });
  }

  void _filterContacts(String query) {
    List<Contact> filteredContacts = _contacts
        .where((contact) =>
            contact.displayName != null &&
            contact.displayName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredContacts = filteredContacts;
    });
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': 'Join me on this Eblood app!',
      },
    );
    if (await canLaunch(smsUri.toString())) {
      await launch(smsUri.toString());
    } else {
      throw 'Could not launch $smsUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 4.h, 0, 0),
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const MenuScreen();
                      },
                      transitionDuration: const Duration(seconds: 1),
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
            Padding(
                padding: EdgeInsets.fromLTRB(28.w, 4.h, 0, 0),
                child: Text(
                  'Invite',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) => _filterContacts(value),
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
          child: _filteredContacts.isEmpty
              ? Center(child: Text('No contacts found'))
              : ListView.builder(
                  itemCount: _filteredContacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _filteredContacts[index];
                    return ListTile(
                      title: Text(contact.displayName ?? 'No Name'),
                      subtitle: Text(contact.phones!.isNotEmpty
                          ? contact.phones!.first.value!
                          : 'No Phone Number'),
                      trailing: IconButton(
                        icon: Icon(Icons.message),
                        onPressed: contact.phones!.isNotEmpty
                            ? () => _sendSMS(contact.phones!.first.value!)
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
