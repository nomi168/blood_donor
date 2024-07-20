// ignore_for_file: file_names

import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:blood_donor/Modals/ChatRequest.dart';
import 'package:blood_donor/Modals/Taker.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/MapOnDonator.dart';
import 'package:blood_donor/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class FeedScreen extends StatefulWidget {
  final String id;
  const FeedScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with WidgetsBindingObserver {
  int index = 1;
  List<Taker> feedsData = [];
  List<ChatRequest> chatrequestData = [];
  String profilename = '';
  String name = '';
  String number = '';
  String image = '';
  String notifi = '';
  int requestid = 0;
  String userType = '';

  String taker_email = '';
  String sender_id = '';
  String receiver_id = '';
  bool isLoading = true;
  // static int takerId = 0;

  @override
  void initState() {
    super.initState();
    getTakerData();
    getChatRequestData();
    getChatRequestId();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        // Populate feedsData with actual data
      });
    });
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
      log("My State is $state");
      updateStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      log("My State is $state");
      updateStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFFFFFFF),
          body: Column(
            children: [
              Row(
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
                            backgroundColor: index == 1
                                ? const Color(0xFFDE0A1E)
                                : const Color(0xFFFFFFFF),
                            minimumSize: Size(double.infinity, 6.h),
                          ),
                          child: Text(
                            'Feed',
                            style: TextStyle(
                              color: index == 1
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF353535),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              index = 1;
                            });
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
                            backgroundColor: index == 2
                                ? const Color(0xFFDE0A1E)
                                : const Color(0xFFFFFFFF),
                            minimumSize: Size(double.infinity, 6.h),
                          ),
                          child: Text(
                            'Request',
                            style: TextStyle(
                              color: index == 2
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF353535),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              index = 2;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: index == 1
                    ? FeedButton()
                    : index == 2
                        ? RequestButton()
                        : Container(), // Add more conditions as needed
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> getTakerData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Taker> tempList = [];

        for (var doc in querySnapshot.docs) {
          if (doc['email'] == userEmail) {
            continue;
          } else {
            DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
            String documentId = documentSnapshot.id;

            tempList.add(Taker(
                t_id: documentId,
                id: doc['taker_id'],
                name: doc['name'],
                imageURL: doc['image'],
                blood: doc['blood'],
                location: doc['location'],
                hospitaname: doc['hospitalname'],
                rating: doc['rating'],
                time: doc['time'],
                date: doc['date'],
                note: doc['note'],
                email: doc['email'],
                number: doc['number'],
                status: doc['status'],
                tak_id: doc['id'] ?? ''));
          }
          setState(() {
            feedsData = tempList;
          });
          getUserDataByEmail();
        }
        // String imageURL = await getImageURL(doc['image']);
      } else {
        print('No documents found in the taker collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<String> getImageURL(String imagePath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error fetching image URL: $e');
      return ''; // Return empty string if error occurs
    }
  }

  Future<void> getChatRequestData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_request')
          .where('status', isEqualTo: 'pending')
          .where('recipientEmail', isEqualTo: userEmail)
          .get();
      print('nomi');

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          chatrequestData = querySnapshot.docs.map((doc) {
            Timestamp timestamp = doc['timestamp'];
            DateTime dateTime = timestamp.toDate();
            String formattedTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

            return ChatRequest(
              receiver_id: doc['receiver_id'],
              sender_id: doc['sender_id'],
              senderemail: doc['senderEmail'],
              receivername: doc['name'],
              receiverimage: doc['receiverimage'],
              senderimage: doc['image'],
              sendername: doc['senderName'],
              sendernumber: doc['senderNumber'],
              receiveremail: doc['recipientEmail'],
              status: doc['status'],
              time: formattedTime,
            );
          }).toList();
        });
      } else {
        print('No pending chat requests found');
        // Clear chatrequestData to remove any previously fetched data
        setState(() {
          chatrequestData = [];
        });
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> getChatRequestId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_request')
          .orderBy('id', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        int userId = userDoc['id'];
        requestid = userId;

        print('Request ID: $requestid');
      } else {
        print('No documents found in the Chat Request collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

//
  // ignore: non_constant_identifier_names
  Widget RequestButton() {
    getChatRequestData();
    if (chatrequestData == null) {
      return Center(child: CircularProgressIndicator());
    } else if (chatrequestData.isEmpty) {
      return Center(child: Text('No chat requests available'));
    } else {
      return RefreshIndicator(
        color: Colors.red,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            getChatRequestData();
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: chatrequestData.length,
              itemBuilder: (context, index) {
                if (isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 160,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                } else {
                  ChatRequest chat = chatrequestData[index];
                  return CouponCard(
                    curveAxis: Axis.vertical,
                    firstChild: Container(
                      // alignment: Alignment.topLeft,
                      decoration: BoxDecoration(color: Colors.grey),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: chat.senderemail.isNotEmpty
                                ? chat.senderimage
                                : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                            placeholder: (context, url) =>
                                const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    secondChild: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                      ),
                      padding: const EdgeInsets.only(top: 0, left: 10),
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                // margin: const EdgeInsets.only(
                                //     bottom: 1, right: 1),
                                width: 50,
                                height: 50,

                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                  ),
                                ),
                              )),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(top: 40),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    chat.sendername,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFDE0A1E)),
                                    ),
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFDE0A1E)),
                                    ),
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (chatrequestData.length > 0) {
                                        String recipientEmail =
                                            chat.receiveremail;
                                        String nam = chat.receivername;
                                        String image1 = chat.receiverimage;
                                        String sender = chat.senderemail;
                                        String acceptname = chat.sendername;
                                        String senderimage = chat.senderimage;
                                        String senderid = chat.sender_id;
                                        String receiverid = chat.receiver_id;

                                        // Send chat request
                                        await AcceptChat(
                                            nam,
                                            recipientEmail,
                                            image1,
                                            sender,
                                            acceptname,
                                            senderimage,
                                            senderid,
                                            receiverid);
                                      } else {
                                        print('Invalid index: $index');
                                      }
                                    },
                                  ))
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                }
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5,
                mainAxisExtent: 120,
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> getUserDataByEmail() async {
    try {
      // Use the 'where' method to query documents with the specified email
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data
        String id = userDoc['id'];
        String email = userDoc['email'];
        String name = userDoc['firstname'];
        String name1 = userDoc['lastname'];
        String n = userDoc['phonenumber'];
        String img = userDoc['image'];
        String type = userDoc['type'];

        setState(() {
          profilename = name + ' $name1';
          number = n;
          image = img;
          userType = type;
          taker_email = email;
          sender_id = id;
        });

        print(profilename);
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> sendChatRequest(
      String senderEmail,
      String recipientEmail,
      String name,
      String number,
      String image,
      String rname,
      String rimage,
      String id) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Query to check if senderEmail already exists
      final QuerySnapshot senderSnapshot = await _firestore
          .collection('chat_request')
          .where('senderEmail', isEqualTo: senderEmail)
          .where('recipientEmail', isEqualTo: recipientEmail)
          .get();

      // If senderEmail already exists, don't send chat request
      if (senderSnapshot.docs.isNotEmpty) {
        print('Sender email already exists. Chat request not sent.');
        EasyLoading.showError('Already Send Chat Request to $recipientEmail');
        return;
      }

      // If senderEmail does not exist, send chat request
      await _firestore.collection('chat_request').add({
        'receiver_id': id,
        'sender_id': sender_id,
        'senderEmail': senderEmail,
        'name': rname,
        'receiverimage': rimage,
        'recipientEmail': recipientEmail,
        'senderName': name,
        'senderNumber': number,
        'image': image,
        'status': 'pending', // or 'accepted', 'rejected', etc.
        'timestamp': FieldValue.serverTimestamp(),
      });
      // showCustomSnackBar(context, 'Chat request sent successfully.', true);
      EasyLoading.showSuccess('Chat request sent to $rname');

      // Call function to send request (not sure about this function)
      SendRequest(recipientEmail);
    } catch (error) {
      print("Error sending chat request: $error");
    }
  }

  void SendRequest(String email) async {
    try {
      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        // Get the device token and email from the user document
        String deviceToken = userDoc['deviceToken'];
        String f = userDoc['firstname'];
        String l = userDoc['lastname'];
        String name = f + " " + l;

        print("Device Token $deviceToken");

        // Prepare notification data
        var data = {
          'to': deviceToken,
          'priority': 'high',
          'notification': {
            'title': 'Chat Request',
            'body': 'You have a new Chat Request.'
          },
          'data': {
            'type': 'request_notification',
            'id': 'Nomi12345'
          } // Additional data if needed
        };

        // Send notification to the device
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAhM4yLBU:APA91bFYi77T3adopH4ZKF6BwWAMjq0v-zrcByWIs_SukIolxTfIEXBwJLOzxF5GaYiT3xn03Y3gbQ-XWzkESGKMR1awLL3JPoc2x5dHh0uxmi-HSZ8xAHIEcQ0fF6XJ5j6KiYsyDzvU'
          },
        );

        // Check response status
        if (response.statusCode == 200) {
          print('Notification sent successfully to user: ${name}');
        } else {
          print(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> AcceptChat(
      String name,
      String email,
      String image,
      String senderemail,
      String acceptn,
      String image1,
      String send_id,
      String receive_id) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Get current date and time
      DateTime now = DateTime.now();

      // Format date
      String formattedDate = DateFormat('MM-dd-yyyy').format(now);

      // Format time
      String formattedTime = DateFormat('h:mm a').format(now);

      // Increment acceptid (if needed)

      // If senderEmail does not exist, send chat request
      DocumentReference docRef =
          await _firestore.collection('chat_accept').add({
        'id': '',
        'sender_id': send_id,
        'receiver_id': receive_id,
        'name': name,
        'accepteremail': email,
        'senderemail': senderemail,
        'date': formattedDate,
        'time': formattedTime,
        'image': image,
        'acceptername': acceptn,
        'senderimage': image1
      });
      String documentId = docRef.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chat_id', documentId);

      // Update the document with the document ID in place of 'takerid'
      await docRef.update({
        'id': documentId,
      });

      // Show success message
      EasyLoading.showSuccess('Chat Accept of $email');
      UpdateStatus(senderemail);

      // Call function to send request (not sure about this function)
      AcceptRequest(senderemail);
      setState(() {});
    } catch (error) {
      print("Error sending chat request: $error");
    }
  }

  void AcceptRequest(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? iddd = await prefs.getString('chat_id');

      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        // Get the device token and email from the user document
        String deviceToken = userDoc['deviceToken'];

        print("Device Token $deviceToken");

        // Prepare notification data
        var data = {
          'to': deviceToken,
          'priority': 'high',
          'notification': {
            'title': 'Request Accept',
            'body': 'You have in Chat.',
            'chat_id': '$iddd'
          },
          'data': {
            'type': 'request_notification',
            'id': 'Nomi12345'
          } // Additional data if needed
        };

        // Send notification to the device
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAhM4yLBU:APA91bFYi77T3adopH4ZKF6BwWAMjq0v-zrcByWIs_SukIolxTfIEXBwJLOzxF5GaYiT3xn03Y3gbQ-XWzkESGKMR1awLL3JPoc2x5dHh0uxmi-HSZ8xAHIEcQ0fF6XJ5j6KiYsyDzvU'
          },
        );

        // Check response status
        if (response.statusCode == 200) {
          print('Notification sent successfully to user: ${userDoc.id}');
        } else {
          print(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> UpdateStatus(String senderEmail) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Query to check if senderEmail already exists
      final QuerySnapshot senderSnapshot = await _firestore
          .collection('chat_request')
          .where('senderEmail', isEqualTo: senderEmail)
          .get();

      // If senderEmail already exists, update the status to "accepting" for that document
      if (senderSnapshot.docs.isNotEmpty) {
        print('Sender email already exists. Updating status to "accepting"');
        // Get the reference to the first document where senderEmail matches
        final DocumentReference docRef = senderSnapshot.docs.first.reference;
        // Update only the 'status' field to 'accepting'
        await docRef.update({'status': 'accepting'});
        // EasyLoading.showSuccess('Chat request updated for $senderEmail');
        setState(() {
          getChatRequestData();
        });
        return;
      }
    } catch (error) {
      print("Error sending chat request: $error");
    }
  }

  Widget FeedButton() {
    return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          // Implement your refresh logic here
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            getTakerData();
          });
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
            child: GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: isLoading ? 6 : feedsData.length,
              itemBuilder: (context, index) {
                if (isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 160,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                } else {
                  Taker taker = feedsData[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 0),
                    child:
                        // notifi = feedsData[index].email;

                        Column(
                      children: [
                        Container(
                          height: 160,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: taker.imageURL.isNotEmpty
                                              ? taker.imageURL
                                              : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feedsData[index].name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 220,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Location :',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            feedsData[index]
                                                                .location,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Blood Group :',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        feedsData[index].blood,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Date :',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        feedsData[index].date,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Time :',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        feedsData[index].time,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  final FirebaseAuth _auth =
                                                      FirebaseAuth.instance;
                                                  final User? currentUser =
                                                      _auth.currentUser;
                                                  final String? userEmail =
                                                      currentUser?.email;

                                                  if (currentUser != null) {
                                                    // Get recipient's email (for demo, you can replace this with actual recipient email)
                                                    String recipientEmail =
                                                        feedsData[index].email;
                                                    String rename =
                                                        feedsData[index].name;
                                                    String recimage =
                                                        feedsData[index]
                                                            .imageURL;
                                                    String id = feedsData[index]
                                                        .tak_id!;
                                                    receiver_id = id;

                                                    if (userType == 'donor') {
                                                      // Send chat request
                                                      await sendChatRequest(
                                                          userEmail!,
                                                          recipientEmail,
                                                          profilename,
                                                          number,
                                                          image,
                                                          rename,
                                                          recimage,
                                                          id);
                                                    } else {
                                                      showCustomSnackBar(
                                                          context,
                                                          'Only donors can send chat requests.',
                                                          false);
                                                    }

                                                    // Show notification or navigate to chat screen
                                                  }
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 90,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: PRIMARY_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: Colors.red,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Request',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  String id =
                                                      feedsData[index].id;
                                                  String name =
                                                      feedsData[index].name;
                                                  String email =
                                                      feedsData[index].email;
                                                  String image =
                                                      feedsData[index].imageURL;
                                                  String blood =
                                                      feedsData[index].blood;
                                                  String location =
                                                      feedsData[index].location;
                                                  String hosname =
                                                      feedsData[index]
                                                          .hospitaname;
                                                  String rating =
                                                      feedsData[index]
                                                          .rating
                                                          .toString();

                                                  String time =
                                                      feedsData[index].time;
                                                  String date =
                                                      feedsData[index].date;
                                                  String note =
                                                      feedsData[index].note;
                                                  String taker_id =
                                                      feedsData[index]
                                                          .t_id
                                                          .toString();
                                                  // if (userType == 'donor') {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) {
                                                        return MapOnDonator(
                                                          id: id,
                                                          name: name,
                                                          email: email,
                                                          image: image,
                                                          blood: blood,
                                                          location: location,
                                                          hosname: hosname,
                                                          rating:
                                                              rating.toString(),
                                                          time: time,
                                                          date: date,
                                                          note: note,
                                                        );
                                                      },
                                                      transitionDuration:
                                                          const Duration(
                                                              seconds: 1),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        const begin = Offset(
                                                            10.0,
                                                            0.0); // slide in from the right
                                                        const end = Offset.zero;
                                                        const curve = Curves
                                                            .easeInOutQuart;

                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        var offsetAnimation =
                                                            animation
                                                                .drive(tween);

                                                        return SlideTransition(
                                                          position:
                                                              offsetAnimation,
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  );

                                                  //  else {
                                                  //   showCustomSnackBar(
                                                  //       context,
                                                  //       "Taker is doesnot donate any blood",
                                                  //       false);
                                                  // }
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 90,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: Colors.red,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Donate',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5,
                mainAxisExtent: 170,
              ),
            )));
  }

  Future<void> updateStatus(bool isActive) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'status': isActive});
        log("My Statis is $isActive");
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}

class CoupanCard extends StatefulWidget {
  const CoupanCard({super.key});

  @override
  State<CoupanCard> createState() => _CoupanCardState();
}

class _CoupanCardState extends State<CoupanCard> {
  @override
  Widget build(BuildContext context) {
    return CouponCard(
      height: 300,
      curvePosition: 180,
      curveRadius: 30,
      borderRadius: 10,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.purple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      firstChild: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'CHIRISTMAS SALES',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '16%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'OFF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      secondChild: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 42),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 80),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
          ),
          onPressed: () {},
          child: const Text(
            'REDEEM',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
