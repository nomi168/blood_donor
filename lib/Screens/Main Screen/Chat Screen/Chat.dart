import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'HeroScreen.dart';

class ChatScree1 extends StatefulWidget {
  final String sender_id;
  final String receiver_id;
  final String image;
  final String name;
  final String sendemail;
  final String receiveremail;
  final String senderimage;

  const ChatScree1({
    super.key,
    required this.image,
    required this.name,
    required this.sendemail,
    required this.receiveremail,
    required this.senderimage,
    required this.sender_id,
    required this.receiver_id,
  });

  @override
  State<ChatScree1> createState() => _ChatScree1State();
}

class _ChatScree1State extends State<ChatScree1> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  String userType = '';
  String userEmail1 = '';
  String global_id = '';
  String localid = '';
  String taker_id = '';
  int id = 0;
  List<dynamic> receiverIds = [];
  List<dynamic> senderrIds = [];
  int unique_id = 0;
  bool useractive = false;

  final FocusNode nosw = FocusNode();
  bool isvisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // updateStatus(true);
    getUserDataByEmail();
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotificationData(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationData(message.data);
    });
    getMessages();
    getmessageid();

    // getonline();
  }

  getonline() async {
    await getOnlineOffline();
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

  void _handleNotificationData(Map<String, dynamic> data) async {
    String? id = data['id'];
    if (id != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'notificationId': id,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              if (userType == 'donor')
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HeroScreen(image: widget.image),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'profile-image',
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.image),
                        radius: 20,
                      ),
                    ),
                  ),
                ),
              if (userType == 'taker')
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HeroScreen(image: widget.senderimage),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'profile-image',
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.senderimage),
                        radius: 20,
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      )),
                  StreamBuilder<bool>(
                    stream: getOnlineOffline(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        useractive = snapshot.data!;
                      }
                      return Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          useractive ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Spacer(),
              // InkWell(
              //     splashColor: Colors.transparent,
              //     splashFactory: NoSplash.splashFactory,
              //     onTap: () {},
              //     child: Icon())
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: 60.h,
                child: StreamBuilder<QuerySnapshot>(
                  key: UniqueKey(),
                  stream: getMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No messages'));
                    }

                    List<Map<String, dynamic>> messages = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    List<Widget> messageWidgets = buildMessagesList(messages);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    });
                    return ListView(
                      controller: _scrollController,
                      children: messageWidgets,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          focusNode: FocusNode(),
                          onTapOutside: (event) {
                            nosw.unfocus();
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter your message...',
                            helperStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 15.0,
                            ),
                          ),
                          onChanged: (text) {
                            TextSelection previousSelection =
                                _controller.selection;
                            _controller.text = text;
                            _controller.selection = previousSelection;
                          })
                        ..onTapOutside),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        if (_controller.text.toString().startsWith(' ')) {
                        } else {
                          if (userType == 'donor') {
                            await getmessageid();
                            unique_id++;

                            await sendMessage(
                              widget.sender_id,
                              widget.receiver_id,
                              userEmail1,
                              widget.receiveremail,
                              _controller.text,
                            );
                            _controller.clear();

                            await sendNotificationsToUser(widget.receiveremail);
                          }
                          if (userType == 'taker') {
                            await getmessageid();
                            unique_id++;

                            await sendMessage(
                              widget.sender_id,
                              widget.receiver_id,
                              userEmail1,
                              widget.sendemail,
                              _controller.text,
                            );
                            _controller.clear();
                            await sendNotificationsToUser(widget.sendemail);
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> sendMessage(String senderid, String receiverid,
      String senderEmail, String receiverEmail, String content,
      {bool isImage = false}) async {
    CollectionReference chats =
        FirebaseFirestore.instance.collection('messages');
    DateTime now = DateTime.now();

    // Format the timestamp as a string
    String formattedTime = DateFormat('h:mm a').format(now);

    await chats.add({
      'senderEmail': receiverEmail,
      'receiverEmail': senderEmail,
      'content': content,
      'time': formattedTime,
      'sender_id': senderid,
      'receiver_id': receiverid,
      'isImage': isImage,
      "index": unique_id
    });
  }

  // Stream<QuerySnapshot> getMessages() async* {
  //   try {
  //     List<Stream<QuerySnapshot>> streams = [];

  //     if (userType == 'donor') {
  //       Query<Map<String, dynamic>> senderToReceiverQuery = FirebaseFirestore
  //           .instance
  //           .collection('messages')
  //           .where('sender_id', isEqualTo: localid)
  //           .where('receiver_id', isEqualTo: widget.receiver_id)
  //           .orderBy('index', descending: false);

  //       // Check if there are any documents in senderToReceiverQuery
  //       QuerySnapshot senderToReceiverSnapshot =
  //           await senderToReceiverQuery.get();
  //       if (senderToReceiverSnapshot.docs.isNotEmpty) {
  //         streams.add(senderToReceiverQuery.snapshots());
  //       } else {
  //         // Only execute the alternate query if the first query is empty
  //         Query<Map<String, dynamic>> receiverToSenderQuery = FirebaseFirestore
  //             .instance
  //             .collection('messages')
  //             .where('receiver_id', isEqualTo: localid)
  //             .where('sender_id', isEqualTo: widget.sender_id)
  //             .orderBy('index', descending: false);

  //         QuerySnapshot receiverToSenderSnapshot =
  //             await receiverToSenderQuery.get();
  //         if (receiverToSenderSnapshot.docs.isNotEmpty) {
  //           streams.add(receiverToSenderQuery.snapshots());
  //         }
  //       }
  //     } else {
  //       // Execute this query if the user is not a 'donor'
  //       Query<Map<String, dynamic>> receiverToSenderQuery = FirebaseFirestore
  //           .instance
  //           .collection('messages')
  //           .where('receiver_id', isEqualTo: localid)
  //           .where('sender_id', isEqualTo: widget.sender_id)
  //           .orderBy('index', descending: false);

  //       QuerySnapshot receiverToSenderSnapshot =
  //           await receiverToSenderQuery.get();
  //       if (receiverToSenderSnapshot.docs.isNotEmpty) {
  //         streams.add(receiverToSenderQuery.snapshots());
  //       }
  //     }

  //     // Merge streams into a single stream
  //     if (streams.isNotEmpty) {
  //       yield* StreamGroup.merge<QuerySnapshot>(streams);
  //     } else {
  //       yield* Stream.empty(); // If no documents found, return an empty stream
  //     }
  //   } catch (e) {
  //     print('Error in getMessages: $e');
  //     yield* Stream.empty(); // Return an empty stream if an error occurs
  //   }
  // }

  Stream<QuerySnapshot> getMessages() {
    try {
      List<Stream<QuerySnapshot>> streams = [];

      if (userType == 'donor') {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: localid)
            .where('receiver_id', isEqualTo: widget.receiver_id)
            .orderBy('index', descending: false);

        streams.add(query.snapshots());
      } else {
        var query = FirebaseFirestore.instance
            .collection('messages')
            .where('receiver_id', isEqualTo: localid)
            .where('sender_id', isEqualTo: widget.sender_id)
            .orderBy('index', descending: false);
        streams.add(query.snapshots());
      }

      // Merge streams into a single stream
      return StreamGroup.merge<QuerySnapshot>(streams);
    } catch (e) {
      print(e.toString());
      // Return an empty stream if error occurs
      return Stream.empty();
    }
  }

  List<Widget> buildMessagesList(List<Map<String, dynamic>> dataList) {
    // Sort the messages by time (with seconds)

    dataList.sort((a, b) {
      try {
        DateTime timeA = DateFormat('h:mm:ss a').parse(a['time']);
        DateTime timeB = DateFormat('h:mm:ss a').parse(b['time']);
        return timeA.compareTo(timeB);
      } catch (e) {
        print('Error parsing time: ${e.toString()}');
        return 0;
      }
    });

    return dataList.map((data) => buildMessage(data)).toList();
  }

  Future<void> getAcceptChatDonor(String id) async {
    try {
      // Use the 'where' method to query documents with the specified email
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userEmail = prefs.getString('user_email') ?? '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('sender_id', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access user data
        List<dynamic> receiverId = [];
        for (var doc in querySnapshot.docs) {
          String receiverid = doc['receiver_id'];
          receiverId.add(receiverid);
        }
        receiverIds = receiverId;
        setState(() {});
      } else {
        // No user found with the specified email
        print('User not found with ID:');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> getAcceptChatTaker(String id) async {
    try {
      // Use the 'where' method to query documents with the specified email
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('receiver_id', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access user data
        List<dynamic> senderId = [];
        for (var doc in querySnapshot.docs) {
          String senderid = doc['sender_id'];
          senderId.add(senderid);
        }
        setState(() {
          senderrIds = senderId;
        });
      } else {
        // No user found with the specified email
        print('User not found with ID:');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
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
          // .orderBy('time', descending: false)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data
        String id = userDoc['id'];
        String type = userDoc['type'];
        String email = userDoc['email'];
        // String firstname = userDoc['firstname'];
        // String lastname = userDoc['lastname'];
        // String image = userDoc['image'];
        setState(() {
          userType = type;
          userEmail1 = email;
          localid = id;
        });

        await getOnlineOffline();
        if (userType == 'donor') {
          getAcceptChatDonor(id);
        }
        if (userType == 'taker') {
          getAcceptChatTaker(id);
        }
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Widget buildMessage(Map<String, dynamic> data) {
    bool isMe = data['receiverEmail'] == userEmail1;

    // ignore: unused_local_variable

    // List<Map<String, dynamic>> data1 = [data];
    // data1.sort((a, b) {
    //   // Compare the index values
    //   return a['index'].compareTo(b['index']);
    // });
    // data1.sort((a, b) {
    //   // Parse the time strings into DateTime objects
    //   DateTime timeA = DateTime.parse('1970-01-01 ' + a['time']);
    //   DateTime timeB = DateTime.parse('1970-01-01 ' + b['time']);
    //   // Compare the DateTime objects
    //   return timeA.compareTo(timeB);
    // });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            isMe == false
                ? userType == 'taker'
                    ? Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.senderimage),
                          radius: 20,
                        ))
                    : Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                          radius: 20,
                        ))
                : SizedBox(),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: isMe ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data['content'],
                        style: TextStyle(
                            fontSize: 16,
                            color: isMe ? Colors.white : Colors.black),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        data['time'] != null
                            ? (data['time'])
                            : 'Time not available',
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            isMe == true
                ? userType == 'donor'
                    ? Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.senderimage),
                          radius: 20,
                        ))
                    : Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                          radius: 20,
                        ))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  // Widget buildMessage(Map<String, dynamic> data) {
  //   bool isMe = data['receiverEmail'] == userEmail1;

  //   return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: isMe
  //           ?Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //                   decoration: BoxDecoration(
  //                     color: Colors.red,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             fullname,
  //                             style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           SizedBox(
  //                             width: 30,
  //                           ),
  //                           Text(
  //                             data['time'] != null
  //                                 ? (data['time'])
  //                                 : 'Time not available',
  //                             style:
  //                                 TextStyle(fontSize: 10, color: Colors.white),
  //                           ),
  //                         ],
  //                       ),
  //                       Text(
  //                         data['content'],
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Material(
  //                   color: Colors.transparent,
  //                   child: CircleAvatar(
  //                     backgroundImage: NetworkImage(picture),
  //                     radius: 20,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           : Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Material(
  //                   color: Colors.transparent,
  //                   child: CircleAvatar(
  //                     backgroundImage: NetworkImage(widget.senderimage),
  //                     radius: 20,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[200],
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             widget.name,
  //                             style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           SizedBox(
  //                             width: 30,
  //                           ),
  //                           Text(
  //                             data['time'] != null
  //                                 ? (data['time'])
  //                                 : 'Time not available',
  //                             style:
  //                                 TextStyle(fontSize: 10, color: Colors.black),
  //                           ),
  //                         ],
  //                       ),
  //                       Text(
  //                         data['content'],
  //                         style: TextStyle(fontSize: 16, color: Colors.black),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ));
  // }

  Future<void> getmessageid() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .orderBy('index', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data
        int ind = userDoc['index'];
        unique_id = ind;
      } else {
        // No user found with the specified email
        print('User not found with email: ');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<String?> uploadImage(XFile pickedFile) async {
    try {
      // Get the size of the picked image
      File imageFile = File(pickedFile.path);
      int fileSizeInBytes = await imageFile.length();

      // Check if the file size exceeds 1 MB
      if (fileSizeInBytes > 1024 * 1024) {
        EasyLoading.showInfo('Image size exceeds 1 MB');
        print('Image size exceeds 1 MB.');
        return null;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('messages')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
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

  Stream<bool> getOnlineOffline() {
    try {
      if (userType == 'donor') {
        return FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.receiveremail)
            .snapshots()
            .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data()['status'] ?? false;
          }
          return false;
        });
      } else if (userType == 'taker') {
        return FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.sendemail)
            .snapshots()
            .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data()['status'] ?? false;
          }
          return false;
        });
      } else {
        print('User not found with email');
        // Returning an empty stream to handle the else case
        return Stream.value(false);
      }
    } catch (e) {
      print('Error: $e');
      // Returning an empty stream to handle errors
      return Stream.value(false);
    }
  }

  Future<void> sendNotificationsToUser(String email) async {
    String projectId = 'blood-app-8f4c2';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String deviceToken = userDoc['deviceToken'];
      String name = userDoc['firstname'] + " " + userDoc['lastname'];

      // Prepare notification data (v1 API format)
      var data = {
        'message': {
          'token': deviceToken,
          'notification': {
            'title': 'New Blood Request',
            'body': 'You have a new message from $name',
          },
          'data': {'type': 'request_notification', 'id': 'Nomi12345'}
        }
      };

      // Generate OAuth2 token using service account
      var jsonString = await rootBundle.loadString('images/json/key1.json');
      var clientCredentials =
          auth.ServiceAccountCredentials.fromJson(jsonString);
      // var clientCredentials = auth.ServiceAccountCredentials.fromJson(
      //     await File('images/json/key.json').readAsString());
      var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      var client =
          await auth.clientViaServiceAccount(clientCredentials, scopes);

      var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print("Notification ${client.credentials.accessToken.data}");

      if (response.statusCode == 200) {
        print('Notification sent successfully to user: ${userDoc.id}');
      } else {
        print(
            'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }
}
