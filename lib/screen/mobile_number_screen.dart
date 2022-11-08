import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:user_profile/screen/user_profile.dart';

import '../utils/widgets/button_widget.dart';
import '../utils/widgets/circular_indicator_widget.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  //Common Variables
  late ThemeData themeData;

  // Controllers
  final TextEditingController _mobileNumberCodeController =
      TextEditingController();

  final TextEditingController _otpCodeController = TextEditingController();

  String verificationId = '';
  num? resendToken = 0;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool requestInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return isShowLoading
        ? const CircularIndicator()
        : Scaffold(
            body: SafeArea(
                child: KeyboardDismissOnTap(child: loginScreenBodyUI())),
          );
  }

  Widget loginScreenBodyUI() {
    return Stack(
      children: <Widget>[
        Positioned(
            top: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: formUI()),
        Positioned(
          top: MediaQuery.of(context).size.height / 12,
          left: MediaQuery.of(context).size.width / 2.5,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text(
              'LOGIN',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget formUI() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Container(
        //   height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              textUI('Phone number'),
              const SizedBox(height: 5),
              mobileNumberInput(),
              const SizedBox(height: 30),
              textUI('OTP'),
              const SizedBox(height: 5),
              otp(),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonWidget(
                  text: 'LOGIN',
                  onClicked: _validateOtpInputs,
                  bFullContainerButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textUI(String text) {
    return Text(
      text,
      style: themeData.textTheme.titleMedium!.copyWith(color: Colors.white),
      textAlign: TextAlign.left,
    );
  }

  Widget mobileNumberInput() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 15,
              alignment: Alignment.center,
              child: TextFormField(
                controller: _mobileNumberCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.send,
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (value) {
                  _mobileNumberCodeController.text = value;
                  _validateMobileInputs();
                },
                onSaved: (value) {
                  _mobileNumberCodeController.text = value!;
                },
              ),
            ),
          ),
        ]);
  }

  Widget otp() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _otpCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (value) {
                  _otpCodeController.text = value;
                },
                onSaved: (value) {
                  _otpCodeController.text = value!;
                },
              ),
            ),
          ),
        ]);
  }

  void setLoadingState(bool status) {
    if (mounted) {
      setState(() {
        isShowLoading = status;
      });
    }
  }

  void _validateMobileInputs() async {
    requestInProgress = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setLoadingState(true);
    }
  }

  Future<void> checkForUserRegistration() async {
    // await PreferenceManager.instance.setUserId(firebaseUser!.uid);
    // AppConstants.userModel.uuid = firebaseUser!.uid;
    // AppConstants.userModel.mobileNumber = _mobileNumberCodeController.text;
    // print(AppConstants.userModel.uuid);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        (Route<dynamic> route) => false);
  }

  void _validateOtpInputs() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_otpCodeController.text.isNotEmpty &&
        _otpCodeController.text.length == 6) {
      _formKey.currentState!.save();

      setLoadingState(true);

      // UserModel user = UserModel(
      //     uuid: AppConstants.userModel.uuid,
      //     ipAddress: '',
      //     location: '',
      //     currentDate: DateTime.now(),
      //     generatedQRCode: '',
      //     qrCodePath: '',
      //     dialCode: '+91',
      //     mobileNumber: _mobileNumberCodeController.text);

    }
  }
}
