import 'package:blood_donor/constants.dart';
import 'package:flutter/material.dart';

class CardScanning extends StatefulWidget {
  const CardScanning({super.key});

  @override
  State<CardScanning> createState() => _CardScanningState();
}

class _CardScanningState extends State<CardScanning> {
  TextEditingController nameTEController = TextEditingController(),
      cnicTEController = TextEditingController(),
      dobTEController = TextEditingController(),
      doiTEController = TextEditingController(),
      doeTEController = TextEditingController();

  /// you're required to initialize this model class as method you used
  /// from this package will return a model of CnicModel type
  // CnicModel _cnicModel = CnicModel();

  // Future<void> scanCnic(ImageSource imageSource) async {
  //   /// you will need to pass one argument of "ImageSource" as shown here
  //   // CnicModel cnicModel =
  //   //     await CnicScanner().scanImage(imageSource: imageSource);
  //   setState(() {
  //     _cnicModel = cnicModel;
  //     nameTEController.text = _cnicModel.cnicHolderName;
  //     cnicTEController.text = _cnicModel.cnicNumber;
  //     dobTEController.text = _cnicModel.cnicHolderDateOfBirth;
  //     doiTEController.text = _cnicModel.cnicIssueDate;
  //     doeTEController.text = _cnicModel.cnicExpiryDate;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text('Enter ID Card Details',
                  style: TextStyle(
                      color: Color(kDarkGreyColor),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                  'To verify your Account, please enter your CNIC details.',
                  style: TextStyle(
                      color: Color(kLightGreyColor),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  _dataField(
                      text: 'Name', textEditingController: nameTEController),
                  _cnicField(textEditingController: cnicTEController),
                  _dataField(
                      text: 'Date of Birth',
                      textEditingController: dobTEController),
                  _dataField(
                      text: 'Date of Card Issue',
                      textEditingController: doiTEController),
                  _dataField(
                      text: 'Date of Card Expire',
                      textEditingController: doeTEController),
                  SizedBox(
                    height: 10,
                  ),
                  _getScanCNICBtn(),
                  SizedBox(
                    height: 5,
                  ),
                  _submitButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cnicField({required TextEditingController textEditingController}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(08),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin:
          const EdgeInsets.only(top: 7.0, bottom: 1.0, left: 0.0, right: 0.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CNIC Number',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.card_membership,
                        color: Colors.red,
                      ),
                      // Image.asset("assets/images/cnic.png",
                      //     width: 40, height: 30),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: '41000-0000000-0',
                            hintStyle: TextStyle(color: Color(kLightGreyColor)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 5.0),
                          ),
                          style: TextStyle(
                              color: Color(kDarkGreyColor),
                              fontWeight: FontWeight.bold),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _dataField(
      {required String text,
      required TextEditingController textEditingController}) {
    return Container(

        // shadowColor: Color(kShadowColor),
        // elevation: 5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(08),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                (text == "Name") ? Icons.person : Icons.date_range,
                color: Colors.red,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: (text == "Name") ? "User Name" : 'DD/MM/YYYY',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                            color: Color(kLightGreyColor),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.all(0),
                      ),
                      style: TextStyle(
                          color: Color(kDarkGreyColor),
                          fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.done,
                      keyboardType: (text == "Name")
                          ? TextInputType.text
                          : TextInputType.number,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _getScanCNICBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {
        /// this is the custom dialog that takes 2 arguments "Camera" and "Gallery"
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return CustomDialogBox(onCameraBTNPressed: () {
        //         scanCnic(ImageSource.camera);
        //       }, onGalleryBTNPressed: () {
        //         scanCnic(ImageSource.gallery);
        //       });
        //     });
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('Scan CNIC',
            style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {},
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(12.0),
        child:
            Text('Submit', style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }
}
