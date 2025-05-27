// import 'dart:convert';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:blood_donor/constants.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:screen_brightness/screen_brightness.dart';
// import 'package:sizer/sizer.dart';

// class VoiceCallPage extends StatefulWidget {
//   final String channelName; // Unique channel name for the call
//   final String userToken;
//   final String image;
//   final String name; // Token generated for the user
//   VoiceCallPage(
//       {required this.channelName,
//       required this.userToken,
//       required this.image,
//       required this.name});

//   @override
//   _VoiceCallPageState createState() => _VoiceCallPageState();
// }

// class _VoiceCallPageState extends State<VoiceCallPage> {
//   late final RtcEngine _engine;
//   bool brightness = false;
//   bool mic = false;
//   bool speaker = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAgora();
//   }

//   Future<void> _initializeAgora() async {
//     try {
//       final token = await _fetchToken(widget.channelName);

//       _engine = createAgoraRtcEngine();
//       await _engine.initialize(
//         const RtcEngineContext(appId: '0cfbda7b8adb45b2bccdfd1a80916f44'),
//       );

//       print("Using Token: $token");
//       print("Channel Name: ${widget.channelName}");

//       // Join the channel
//       await _engine.joinChannel(
//         token: token,
//         channelId: widget.channelName,
//         uid: 0,
//         options: const ChannelMediaOptions(),
//       );

//       // Listen for errors
//       _engine.registerEventHandler(
//         RtcEngineEventHandler(
//           onError: (code, description) {
//             print('Error: $code, Description: $description');
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Failed to join call: $description')),
//             );
//           },
//         ),
//       );

//       print('Successfully joined the call');
//     } catch (e) {
//       print("Error initializing Agora: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to initialize call: $e')),
//       );
//     }
//   }

//   Future<String> _fetchToken(String channelName) async {
//     final response = await http.get(
//       Uri.parse(
//           'http://localhost:3000/generateToken?channelName=$channelName&uid=0'),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['token'];
//     } else {
//       throw Exception('Failed to fetch token');
//     }
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }

//   Future<void> _setBrightness(double brightness) async {
//     try {
//       await ScreenBrightness().setApplicationScreenBrightness(brightness);
//     } catch (e) {
//       print("Error setting brightness: $e");
//     }
//   }

//   Future<void> _toggleBrightness() async {
//     try {
//       // Get current brightness
//       double currentBrightness = await ScreenBrightness().application;
//       // Toggle between low and high brightness
//       double newBrightness = currentBrightness < 0.5 ? 1.0 : 0.1;
//       await _setBrightness(newBrightness);
//     } catch (e) {
//       print("Error toggling brightness: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF6F7A82),
//               Color(0xFF5D727E),
//               Color(0xFF112B4A),
//               Color(0xFF0D2445),
//             ],
//             begin: Alignment.topLeft,
//           ),
//         ),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 40,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   splashFactory: NoSplash.splashFactory,
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 26,
//                   ),
//                 ),
//                 Spacer(),
//                 Text(
//                   'Voice Call',
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 ),
//                 Spacer(),
//                 SizedBox(
//                   width: 10,
//                 )
//               ],
//             ),
//             Spacer(),
//             Column(
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: CachedNetworkImage(
//                       fit: BoxFit.cover,
//                       imageUrl: widget.image.isNotEmpty
//                           ? widget.image
//                           : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
//                       placeholder: (context, url) =>
//                           const CupertinoActivityIndicator(
//                         color: Colors.white,
//                       ),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   widget.name,
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 Text(
//                   'In Calling ....',
//                   style: TextStyle(fontSize: 13, color: Colors.white),
//                 )
//               ],
//             ),
//             Spacer(),
//             Container(
//               height: 22.h,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.horizontal(
//                     left: Radius.circular(20), right: Radius.circular(20)),
//                 color: Color(0xff1E1E1E80).withOpacity(0.4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     blurRadius: 20,
//                     spreadRadius: 5,
//                     offset: Offset(0, 1),
//                   ),
//                 ],
//               ),
//               child: Column(children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 40.w),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                     color: Colors.white54,
//                   ),
//                   height: 4,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         splashFactory: NoSplash.splashFactory,
//                         onTap: () {
//                           setState(() {
//                             brightness = true;
//                           });
//                           _toggleBrightness();
//                         },
//                         child: Container(
//                           width: 7.w,
//                           height: 7.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFFFFFFFF29).withOpacity(0.12),
//                           ),
//                           child: Icon(
//                             Icons.light_mode,
//                             size: 28,
//                             color: brightness ? Colors.blue : Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         splashFactory: NoSplash.splashFactory,
//                         onTap: () {
//                           if (mic == false) {
//                             setState(() {
//                               mic = true;
//                             });
//                           } else {
//                             setState(() {
//                               mic = false;
//                             });
//                           }

//                           _engine.muteLocalAudioStream(true);
//                         },
//                         child: Container(
//                           width: 7.w,
//                           height: 7.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFFFFFFFF29).withOpacity(0.12),
//                           ),
//                           child: Icon(
//                             mic == true
//                                 ? CupertinoIcons.mic_off
//                                 : CupertinoIcons.mic,
//                             size: 28,
//                             color: mic ? PRIMARY_COLOR : Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Expanded(
//                     //   child: InkWell(
//                     //     splashColor: Colors.transparent,
//                     //     splashFactory: NoSplash.splashFactory,
//                     //     onTap: () {},
//                     //     child: Container(
//                     //       width: 7.w,
//                     //       height: 7.h,
//                     //       decoration: BoxDecoration(
//                     //         shape: BoxShape.circle,
//                     //         color: Color(0xFFFFFFFF29).withOpacity(0.12),
//                     //       ),
//                     //       child: Icon(
//                     //         Icons.camera_alt,
//                     //         size: 28,
//                     //         color: Colors.white,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     Expanded(
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         splashFactory: NoSplash.splashFactory,
//                         onTap: () {
//                           if (speaker == false) {
//                             setState(() {
//                               speaker = true;
//                             });
//                           } else {
//                             setState(() {
//                               speaker = false;
//                             });
//                           }

//                           _engine.setEnableSpeakerphone(true);
//                         },
//                         child: Container(
//                           width: 7.w,
//                           height: 7.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFFFFFFFF29).withOpacity(0.12),
//                           ),
//                           child: Icon(
//                             speaker ? Icons.volume_up : Icons.volume_down,
//                             size: 28,
//                             color: speaker ? Colors.green : Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   splashFactory: NoSplash.splashFactory,
//                   onTap: () {
//                     _engine.leaveChannel();
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 30.w),
//                     height: 6.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       shape: BoxShape.rectangle,
//                       color: PRIMARY_COLOR,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.call_end_outlined,
//                           size: 28,
//                           color: Colors.white,
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           'End Call',
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
