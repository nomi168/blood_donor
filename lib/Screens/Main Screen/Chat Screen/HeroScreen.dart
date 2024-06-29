import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeroScreen extends StatelessWidget {
  final String image;

  const HeroScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(2.w, 3.h, 0, 0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
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
        )),
      );
    });
  }
}
