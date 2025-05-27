import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeroScreen extends StatelessWidget {
  final String image;

  const HeroScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
            width: double.infinity,
            height: 630,
            child: Center(
              child: Hero(
                tag: 'profile-image',
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
