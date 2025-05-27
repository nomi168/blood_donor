import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteController extends GetxController {
  List<Contact> _contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = false;

  @override
  void onInit() {
    _requestPermissions();
    super.onInit();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      _getAllContacts();
    }
  }

  Future<void> _getAllContacts() async {
    isLoading = true;
    update();

    try {
      final List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);
      _contacts = contacts;
      filteredContacts = List.unmodifiable(_contacts);
    } catch (e) {
      print('Error fetching contacts: $e');
    }

    isLoading = false;
    update();
  }

  void filterContacts(String query) {
    final lowerQuery = query.toLowerCase().trim();

    filteredContacts = _contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      return name.contains(lowerQuery);
    }).toList(growable: false);

    update();
  }

  Future<void> sendSMS(String phoneNumber) async {
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
}
