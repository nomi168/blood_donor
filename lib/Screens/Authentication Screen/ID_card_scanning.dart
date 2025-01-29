import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class IDCARDScanning extends StatefulWidget {
  const IDCARDScanning({super.key});

  @override
  State<IDCARDScanning> createState() => _IDCARDScanningState();
}

class _IDCARDScanningState extends State<IDCARDScanning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.w, 2.h, 0, 0),
            child: Text(
              'Verification Process',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        SvgPicture.asset(
          height: 30.h,
          width: double.infinity,
          'images/svg/Layer_1.svg',
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Setting Up your\nAccount',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'We are analyzing your account',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        _customRow(1, 'Email verified', showIcon: true),
        SizedBox(
          height: 3.h,
        ),
        _customRow(2, 'Checking up your CNIC'),
        // SizedBox(
        //   height: 3.h,
        // ),
        // _customRow(3, 'Verifying your address'),
        SizedBox(height: 3.h),
        // Container(
        //   width: double.infinity,
        //   margin: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
        //   child: Material(
        //     elevation: 3.5,
        //     shadowColor: Colors.black,
        //     borderRadius: BorderRadius.circular(10.0),
        //     child: ElevatedButton(
        //       onPressed: () {

        //       },
        //       style: ButtonStyle(
        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //           RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10.0),
        //           ),
        //         ),
        //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        //           // ignore: prefer_const_constructors
        //           EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
        //         ),
        //         backgroundColor: MaterialStateProperty.all<Color>(
        //             const Color(0xFFDE0A1E)), // Change button color
        //       ),
        //       child: Text(
        //         'Verify',
        //         style: TextStyle(
        //           fontSize: 12.sp, // Adjust the font size
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    ));
  }

  Widget _customRow(int index, String value, {bool showIcon = false}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.red.shade100.withOpacity(0.5),
              ),
              child: showIcon
                  ? Icon(
                      Icons.check, // Replace with the desired icon
                      color: Colors.black,
                      size: 18.sp,
                    )
                  : Text(
                      index.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 12.sp,
              ),
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black45,
          ),
        )
      ],
    );
  }
}
