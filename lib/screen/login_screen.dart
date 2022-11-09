import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:user_profile/preferences/preference_manager.dart';
import 'package:user_profile/screen/introduction.dart';
import 'package:user_profile/screen/sign_up_screen.dart';
import 'package:user_profile/screen/home_screen.dart';
import 'package:user_profile/utils/widgets/common_utils_widget.dart';

import '../utils/widgets/button_widget.dart';
import '../utils/widgets/circular_indicator_widget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //Common Variables
  late ThemeData themeData;

  // Controllers
  final TextEditingController _mobileNumberCodeController =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String verificationId = '';
  num? resendToken = 0;
  bool bAdminMode = false;

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
        : WillPopScope(
            onWillPop: () async {
              return await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const IntroductionScreen()),
              );
            },
            child: Scaffold(
              body: SafeArea(
                  child: KeyboardDismissOnTap(child: loginScreenBodyUI())),
            ),
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
              const SizedBox(height: 80),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text(
                  'Switch to admin mode',
                  style: TextStyle(color: Colors.white),
                ),
                switchUI()
              ]),
              textUI('Phone number/ Email'),
              const SizedBox(height: 5),
              mobileNumberInput(),
              const SizedBox(height: 30),
              textUI('Password'),
              const SizedBox(height: 5),
              passwordUI(),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonWidget(
                  text: 'LOGIN',
                  onClicked: _navigate,
                  bFullContainerButton: true,
                ),
              ),
              logOutTextAndButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget switchUI() {
    return Switch(
      // thumb color (round icon)
      activeColor: const Color.fromARGB(255, 1, 16, 39),
      activeTrackColor: Colors.cyan,
      inactiveThumbColor: Colors.blueGrey.shade600,
      inactiveTrackColor: Colors.grey.shade400,
      splashRadius: 50.0,
      // boolean variable value
      value: bAdminMode,
      // changes the state of the switch
      onChanged: (value) => setState(() {
        print('--$value');
        bAdminMode = value;
        if (value == true) {
          _mobileNumberCodeController.text = 'Admin';
          _passwordController.text = '0000';
        } else {
          _mobileNumberCodeController.text = '';
          _passwordController.text = '';
        }
      }),
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
    return TextFormField(
      controller: _mobileNumberCodeController,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.send,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter valid phone number / mailId";
        }
      },
      decoration:
          const InputDecoration(fillColor: Color.fromARGB(255, 1, 16, 39)),
      style: const TextStyle(color: Colors.white),
      onFieldSubmitted: (value) {
        _mobileNumberCodeController.text = value;
      },
      onSaved: (value) {
        _mobileNumberCodeController.text = value!;
      },
    );
  }

  Widget passwordUI() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter password";
        }
      },
      decoration:
          const InputDecoration(fillColor: Color.fromARGB(255, 1, 16, 39)),
      onFieldSubmitted: (value) {
        _passwordController.text = value;
      },
      onSaved: (value) {
        _passwordController.text = value!;
      },
    );
  }

  void setLoadingState(bool status) {
    if (mounted) {
      setState(() {
        isShowLoading = status;
      });
    }
  }

  Widget logOutTextAndButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account ? ',
          style: themeData.textTheme.bodyText2!.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            //  PreferenceManager.instance.clearAll();

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: Text(
            'Sign Up',
            style: themeData.textTheme.subtitle1!.copyWith(color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _navigate() async {
    FocusManager.instance.primaryFocus?.unfocus();

    _formKey.currentState!.save();
    if (!bAdminMode) {
      String password = await PreferenceManager.instance.getPassword();
      String mail = await PreferenceManager.instance.getEmail();
      String phoneNumber = await PreferenceManager.instance.getMobileNumber();

      if (mail != _mobileNumberCodeController.text ||
          phoneNumber == _mobileNumberCodeController.text) {
        CommonUtils.instance.showSnackBar(context,
            'PhoneNumber or mailId does not exist, please try again', 'N');
      } else if (password != _passwordController.text) {
        CommonUtils.instance.showSnackBar(
            context, 'Password does not match , please try again', 'N');
      } else {
        setLoadingState(true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      mobileOrMail: _mobileNumberCodeController.text,
                      password: _passwordController.text,
                      bAdmin: bAdminMode,
                    )),
            (Route<dynamic> route) => false);

        setLoadingState(false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    mobileOrMail: _mobileNumberCodeController.text,
                    password: _passwordController.text,
                    bAdmin: bAdminMode,
                  )),
          (Route<dynamic> route) => false);
    }

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
