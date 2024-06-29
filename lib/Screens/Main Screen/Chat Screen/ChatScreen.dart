// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Chat%20Screen/HeroScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  final String image;
  final String name;
  final String sendemail;
  final String receiveremail;
  const ChatScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.sendemail,
      required this.receiveremail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  // void _handleSubmitted(String text) {
  //   _textController.clear();
  //   setState(() {
  //     _messages.add({'type': 'text', 'data': text, 'sender': 'Me'});
  //   });
  // }

  void _handleFileSelected(String filePath, String type) {
    setState(() {
      _messages.add({'type': type, 'data': filePath, 'sender': 'Me'});
    });
  }

  Widget _buildTextComposer() {
    final ThemeData theme = Theme.of(context);
    return IconTheme(
      data: IconThemeData(color: theme.cardColor),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 13.h),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Colors.black,
              onPressed: () {
                // Handle file attachment, show a file picker, etc.
                // For simplicity, let's assume a file path is selected.
                _handleFileSelected('/path/to/file', 'file');
              },
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                // onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.black,
              onPressed: () => sendMessage(
                  widget.sendemail, widget.receiveremail, _textController.text),
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              color: Colors.black,
              onPressed: () {
                // Handle voice message recording and sending.
                // For simplicity, let's assume a voice message is recorded and stored.
                _handleFileSelected('/path/to/voice_message', 'voice');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Expanded(
              child: Row(
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
                  Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ))
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Handle menu button press
                  // You can show a menu or perform any other action
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    switch (message['type']) {
                      case 'text':
                        return ListTile(
                          title: Text(message['data']),
                        );
                      case 'file':
                        return ListTile(
                          title: Text('File: ${message['data']}'),
                        );
                      case 'voice':
                        return ListTile(
                          title: Text('Voice Message: ${message['data']}'),
                        );

                      default:
                        return Container();
                    }
                  },
                ),
              ),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      );
    });
  }

  void sendMessage(
      String senderEmail, String receiverEmail, String messageContent) async {
    try {
      // Store message in the database
      await FirebaseFirestore.instance.collection('messages').add({
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'content': messageContent,
        'timestamp':
            DateTime.now(), // You can use Firestore server timestamp instead
      });
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
