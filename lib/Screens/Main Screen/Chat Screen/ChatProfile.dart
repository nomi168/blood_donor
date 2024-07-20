import 'package:blood_donor/Modals/AcceptChat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Chat.dart';

class ChatProfile extends StatefulWidget {
  const ChatProfile({super.key});

  @override
  State<ChatProfile> createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> with WidgetsBindingObserver {
  List<AcceptChat> chatrequestData = [];
  String usertype = '';
  String id = '';

  @override
  void initState() {
    super.initState();

    getChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0.w, 5.h, 0, 0),
                child: Text(
                  'Inbox',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                )),
            if (chatrequestData.isEmpty)
              Center(
                child: Text(
                  'No Person Inbox',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
            if (chatrequestData.isNotEmpty)
              Expanded(
                  child: usertype == 'donor'
                      ? ListView.builder(
                          itemCount: chatrequestData.length,
                          itemBuilder: (context, index) {
                            final chat = chatrequestData[index];
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    String sender_id = chat.sender_id;
                                    String receiver_id = chat.receiver_id;
                                    String image = chat.image;
                                    String name = chat.name;
                                    String sendemail = chat.senderemail;
                                    String receiveremail = chat.receiveremail;
                                    String senderimage = chat.senderimage;

                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return ChatScree1(
                                            sender_id: sender_id,
                                            receiver_id: receiver_id,
                                            image: image,
                                            name: name,
                                            sendemail: sendemail,
                                            receiveremail: receiveremail,
                                            senderimage: senderimage,
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(10.0,
                                              0.0); // slide in from the right
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOutQuart;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: chat.image,
                                        placeholder: (context, url) =>
                                            const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),

                                  title: Text(chat.name),
                                  // subtitle: Text(chat['message']),
                                  trailing: Text(chat.time),
                                ),
                                const Divider(
                                  color: Colors.black26,
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: chatrequestData.length,
                          itemBuilder: (context, index) {
                            final chat = chatrequestData[index];
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    String sender_id = chat.sender_id;
                                    String receiver_id = chat.receiver_id;
                                    String image = chat.image;
                                    String name = chat.acceptname;
                                    String sendemail = chat.senderemail;
                                    String receiveremail = chat.receiveremail;
                                    String senderimage = chat.senderimage;
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return ChatScree1(
                                              sender_id: sender_id,
                                              receiver_id: receiver_id,
                                              image: image,
                                              name: name,
                                              sendemail: sendemail,
                                              receiveremail: receiveremail,
                                              senderimage: senderimage);
                                        },
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(10.0,
                                              0.0); // slide in from the right
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOutQuart;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: chat.senderimage,
                                        placeholder: (context, url) =>
                                            const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text(chat.acceptname),
                                  // subtitle: Text(chat['message']),
                                  trailing: Text(chat.time),
                                ),
                                const Divider(
                                  color: Colors.black26,
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          },
                        )),
          ]),
        ),
      );
    });
  }

  Future<void> getChatUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        usertype = userDoc['type'];
        id = userDoc['id'];

        if (usertype == 'donor') {
          QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
              .collection('chat_accept')
              .where('senderemail', isEqualTo: userEmail)
              .get();
          print('nomi');

          if (chatQuerySnapshot.docs.isNotEmpty) {
            setState(() {
              chatrequestData = chatQuerySnapshot.docs.map((doc) {
                // Timestamp timestamp = doc['timestamp'];
                // DateTime dateTime = timestamp.toDate();
                // String formattedTime =
                //     DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                return AcceptChat(
                    sender_id: doc['sender_id'],
                    receiver_id: doc['receiver_id'],
                    senderemail: doc['senderemail'],
                    receiveremail: doc['accepteremail'],
                    name: doc['name'],
                    image: doc['image'],
                    date: doc['date'],
                    time: doc['time'],
                    acceptname: doc['acceptername'],
                    senderimage: doc['senderimage']);
              }).toList();
            });
          } else {
            print('No pending chat requests found');
            // Clear chatrequestData to remove any previously fetched data
            setState(() {
              chatrequestData = [];
            });
          }
        } else if (usertype == 'taker') {
          QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
              .collection('chat_accept')
              .where('accepteremail', isEqualTo: userEmail)
              .get();
          print('nomi');

          if (chatQuerySnapshot.docs.isNotEmpty) {
            setState(() {
              chatrequestData = chatQuerySnapshot.docs.map((doc) {
                // Timestamp timestamp = doc['timestamp'];
                // DateTime dateTime = timestamp.toDate();
                // String formattedTime =
                //     DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                return AcceptChat(
                    sender_id: doc['sender_id'],
                    receiver_id: doc['receiver_id'],
                    senderemail: doc['senderemail'],
                    receiveremail: doc['accepteremail'],
                    name: doc['name'],
                    image: doc['image'],
                    date: doc['date'],
                    time: doc['time'],
                    acceptname: doc['acceptername'],
                    senderimage: doc['senderimage']);
              }).toList();
            });
          } else {
            print('No pending chat requests found');
            // Clear chatrequestData to remove any previously fetched data
            setState(() {
              chatrequestData = [];
            });
          }
        } else {
          print("Error");
        }
      } else {
        print('No documents found in the Chat Request collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  String getConversationID(String id, FirebaseAuth auth) {
    User user = auth.currentUser!;
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
  //     Taker user) {
  //   return firestore
  //       .collection('chats/${getConversationID(user.id.toString(),FirebaseAuth.instance)}/messages/')
  //       .orderBy('sent', descending: true)
  //       .snapshots();
  // }
  //  static Future<void> sendMessage(
  //     Taker chatUser, String msg, Type type) async {
  //   //message sending time (also used as id)
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   //message to send
  //   final Message message = Message(
  //       : chatUser.id,
  //       msg: msg,
  //       read: '',
  //       type: type,
  //       fromId: user.uid,
  //       sent: time);

  //   final ref = firestore
  //       .collection('chats/${getConversationID(chatUser.id.toString(),FirebaseAuth.instance)}/messages/');
  //   await ref.doc(time).set(message.toJson()).then((value) =>
  //       sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  // }
}


// Function to send a message
// void sendMessage(String senderEmail, String receiverEmail, String messageContent) async {
//   try {
//     // Store message in the database
//     await FirebaseFirestore.instance.collection('messages').add({
//       'senderEmail': senderEmail,
//       'receiverEmail': receiverEmail,
//       'content': messageContent,
//       'timestamp': DateTime.now(), // You can use Firestore server timestamp instead
//     });
//     print('Message sent successfully');
//   } catch (e) {
//     print('Error sending message: $e');
//   }
// }

// // Function to fetch messages for a conversation
// Future<List<Message>> fetchMessages(String senderEmail, String receiverEmail) async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('messages')
//         .where('senderEmail', isEqualTo: senderEmail)
//         .where('receiverEmail', isEqualTo: receiverEmail)
//         .orderBy('timestamp', descending: true)
//         .get();

//     List<Message> messages = querySnapshot.docs.map((doc) {
//       return Message(
//         senderEmail: doc['senderEmail'],
//         receiverEmail: doc['receiverEmail'],
//         content: doc['content'],
//         timestamp: doc['timestamp'].toDate(),
//       );
//     }).toList();

//     return messages;
//   } catch (e) {
//     print('Error fetching messages: $e');
//     return [];
//   }
// }

// // Message model class
// class Message {
//   final String senderEmail;
//   final String receiverEmail;
//   final String content;
//   final DateTime timestamp;

//   Message({required this.senderEmail, required this.receiverEmail, required this.content, required this.timestamp});
// }
