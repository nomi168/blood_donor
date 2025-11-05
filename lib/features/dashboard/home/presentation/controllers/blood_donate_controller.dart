import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class BloodDonateController extends GetxController {
  final BloodBank bankModel;
  final String selectedBloodType;
  BloodDonateController(
      {required this.bankModel, required this.selectedBloodType});
  final HomeRepository _repository = HomeRepository();
  TextEditingController donorName = TextEditingController();
  TextEditingController donorEmail = TextEditingController();
  TextEditingController donorNumber = TextEditingController();
  TextEditingController donorAddress = TextEditingController();
  TextEditingController donorbloodGroup = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController bankEmail = TextEditingController();
  TextEditingController bankAddress = TextEditingController();
  TextEditingController selectedBlood = TextEditingController();

  @override
  void onInit() {
    donorName.text =
        '${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname}';
    donorEmail.text = UserController.to.userModel!.email;
    donorAddress.text = UserController.to.userModel!.location;
    donorNumber.text = UserController.to.userModel!.phonenumber;
    donorbloodGroup.text = UserController.to.userModel!.bloodgroup;
    bankName.text = bankModel.name;
    bankEmail.text = bankModel.email;
    bankAddress.text = bankModel.address;
    selectedBlood.text = selectedBloodType;
    super.onInit();
  }

  Future<bool> sendEmail(Map<String, dynamic> payload) async {
    try {
      showLoader('sending email...');

      String username = 'noumansaeed171@gmail.com';
      String password = 'jasi nudu wyrs xmdo'; // App password

      final smtpServer = gmail(username, password);

      // Build email body from payload
      final emailBody = """
<html>
  <body style="font-family: Arial, sans-serif; background-color: #f6f6f6; padding: 20px; margin:0;">
    <table width="100%" style="max-width: 600px; margin:auto; background: #ffffff; border-radius: 8px; padding: 20px; box-shadow:0 2px 6px rgba(0,0,0,0.1);">

      <tr>
        <td align="center" style="padding-bottom:20px;">
          <img src="https://firebasestorage.googleapis.com/v0/b/blood-app-8f4c2.appspot.com/o/bloodsplash.png?alt=media&token=af6bcfb7-a9ad-4542-bfd9-0fb84351704d" width="100" alt="E-Blood Logo" style="margin-bottom:10px;" />
          <h2 style="color: #d9534f; margin:0;">New Donor Registration</h2>
          <p style="color:#777; font-size:14px; margin:5px 0 0 0;">Saving Lives, One Drop at a Time ❤️</p>
        </td>
      </tr>

      <!-- Body Content -->
      <tr>
        <td style="font-size: 16px; color: #333; line-height:1.6;">
          Dear <b>Admin</b>,<br><br>
          A new donor has been registered through the <b>E-Blood App</b>. Below are the details:<br><br>

          <table width="100%" style="border:1px solid #eee; border-radius:6px; margin-top:10px;" cellpadding="10">
            <tr>
              <td><b>Donor Name:</b></td>
              <td>${payload['donor_name']}</td>
            </tr>
            <tr>
              <td><b>Donor Email:</b></td>
              <td>${payload['donor_email']}</td>
            </tr>
            <tr>
              <td><b>Donor Number:</b></td>
              <td>${payload['donor_number']}</td>
            </tr>
            <tr>
              <td><b>Donor Address:</b></td>
              <td>${payload['donor_address']}</td>
            </tr>
            <tr>
              <td><b>Donor Blood Group:</b></td>
              <td>${payload['donor_blood']}</td>
            </tr>
            <tr>
              <td><b>Bank Name:</b></td>
              <td>${payload['bank_name']}</td>
            </tr>
            <tr>
              <td><b>Bank Email:</b></td>
              <td>${payload['bank_email']}</td>
            </tr>
            <tr>
              <td><b>Bank Address:</b></td>
              <td>${payload['bank_address']}</td>
            </tr>
            <tr>
              <td><b>Selected Blood:</b></td>
              <td>${payload['selected_blood']}</td>
            </tr>
            <tr>
              <td><b>Created At:</b></td>
              <td>${payload['createdAt']}</td>
            </tr>
          </table>

          <br>
          Best regards,<br>
          <b>The E-Blood Team</b>
        </td>
      </tr>

      <!-- Footer -->
      <tr>
        <td align="center" style="padding-top:30px;">
          <hr style="border:none; border-top:1px solid #eee; margin:20px 0;">
          <img src="https://media.giphy.com/media/jn8HrkAeMZp6w/giphy.gif" alt="Blood Drop" width="60" style="margin-bottom:10px;" />
          <p style="font-size:14px; color:#555; margin:0 20px;">
            <b>E-Blood</b> is a smart blood donation platform connecting donors and patients instantly.<br>
            Our mission is to <span style="color:#d9534f; font-weight:bold;">save lives through technology</span>  
            by making blood availability fast, reliable, and transparent.
          </p>
          <p style="font-size:12px; color:#aaa; margin-top:15px;">
            © 2025 E-Blood App • Bringing Hope Through Every Drop
          </p>
        </td>
      </tr>
    </table>
  </body>
</html>
""";

      final message = Message()
        ..from = Address(username, 'E-Blood App')
        ..recipients.add(payload['donor_email']) // blood bank admin
        ..subject = '🩸 New Donor Registration'
        ..html = emailBody;

      final sendReport = await send(message, smtpServer);
      logSuccess('✅ Email sent: $sendReport');
      return true;
    } on MailerException catch (e) {
      logError('❌ Email not sent. $e');
      for (var p in e.problems) {
        logError('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> addBloodBankDonor(Map<String, dynamic> payload) async {
    try {
      showLoader('adding blood bank donor...');
      return await _repository.addBloodBankDonor(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding blood bank donor data!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
