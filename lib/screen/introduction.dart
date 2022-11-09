import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:user_profile/screen/login_screen.dart';
import 'package:user_profile/screen/sign_up_screen.dart';

import '../utils/widgets/button_widget.dart';
import '../utils/widgets/circular_indicator_widget.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  //Common Variables
  late ThemeData themeData;

  bool isShowLoading = false;

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
          left: MediaQuery.of(context).size.width / 3,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text(
              'WELCOME',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget formUI() {
    return Container(
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
            const SizedBox(height: 70),

            Text(
              'Lets Get Started !!',
              style:
                  themeData.textTheme.titleLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 45),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonWidget(
                text: 'LOGIN',
                onClicked: _navigateToLogin,
                bFullContainerButton: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'OR',
              style:
                  themeData.textTheme.titleLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            //   otp(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonWidget(
                text: 'SIGNUP',
                onClicked: _navigateToSignUp,
                bFullContainerButton: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSignUp() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
        (Route<dynamic> route) => false);
  }

  void _navigateToLogin() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LogInScreen()),
        (Route<dynamic> route) => false);
  }
}
