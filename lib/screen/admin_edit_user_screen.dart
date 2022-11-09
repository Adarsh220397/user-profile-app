import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile/screen/introduction.dart';
import 'package:user_profile/screen/home_screen.dart';

import 'package:user_profile/service/model/user_details.dart';
import 'package:user_profile/utils/widgets/button_widget.dart';
import 'package:user_profile/utils/widgets/circular_indicator_widget.dart';

class EditUserScreen extends StatefulWidget {
  final UserDetails? userInfo;
  const EditUserScreen({super.key, this.userInfo});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late ThemeData themeData;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    isLoading = true;

    _passwordController.text = widget.userInfo!.password;

    _emailController.text = widget.userInfo!.email;

    _mobileNumberController.text = widget.userInfo!.mobile;

    _userNameController.text = widget.userInfo!.userName;

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return isLoading
        ? const CircularIndicator()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('USER DETAILS'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroductionScreen()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: KeyboardDismissOnTap(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //  for (UserDetails user in filterList) userProfileUI(user),

                      userProfileUI()
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget userProfileUI() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 5),
            profilePictureWidget(),
            const SizedBox(height: 15),
            //   textInputUI(_userIdController, 'User ID'),
            const SizedBox(height: 15),
            textInputUI(_userNameController, 'Name'),
            const SizedBox(height: 15),
            textInputUI(_emailController, 'Email'),
            const SizedBox(height: 15),
            textInputUI(_mobileNumberController, 'Mobile Number'),
            const SizedBox(height: 15),
            textInputUI(_passwordController, 'Password'),
            const SizedBox(height: 15),
            ButtonWidget(text: 'UPDATE', onClicked: () => onClicked()),
          ],
        ),
      ),
    );
  }

  onClicked() async {
    bool? bFilePicked;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      isLoading = true;
      // if (await PreferenceManager.instance.getMobileNumber() ==
      //         _mobileNumberController.text ||
      //     await PreferenceManager.instance.getEmail() ==
      //         _emailController.text) {
      //   CommonUtils.instance.showSnackBar(context,
      //       "This mobile number or mail Id is already signed up.", "N");
      // } else {
      //   if (pickedFile == null) {
      //     bFilePicked = false;
      //     await PreferenceManager.instance.setImage('');
      //   } else {
      //     bFilePicked = true;
      //     await PreferenceManager.instance.setImage(pickedFile!.path);
      //   }
      //   await PreferenceManager.instance.setName(_userNameController.text);

      //   await PreferenceManager.instance.setPassword(_passwordController.text);

      //   await PreferenceManager.instance
      //       .setMobileNumber(_mobileNumberController.text);
      //   await PreferenceManager.instance.setEmail(_emailController.text);

      UserDetails user = UserDetails(
          imagePath: pickedFile == null ? 'no file' : pickedFile!.path,
          userName: _userNameController.text,
          email: _emailController.text,
          mobile: _mobileNumberController.text,
          password: _passwordController.text,
          userId: 3);

      isLoading = false;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(bAdmin: true, userInfo: user)),
          (Route<dynamic> route) => false);
    }
  }

  Widget textInputUI(TextEditingController? controller, String text) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter the correct value";
        }
      },
      style: const TextStyle(color: Colors.white),
      onFieldSubmitted: (value) {
        controller!.text = value;
      },
      onSaved: (value) {
        controller!.text = value!;
      },
      autocorrect: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: text,
        hintText: text,
      ),
    );
  }

  Widget profilePictureWidget() {
    return GestureDetector(
      onTap: () async {
        pickedFile = (await _picker.pickImage(source: ImageSource.gallery));
        if (pickedFile == null) return;
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: pickedFile != null
                        ? Image.file(File(pickedFile!.path), fit: BoxFit.fill)
                        : widget.userInfo!.imagePath.isNotEmpty
                            ? Image.file(File(widget.userInfo!.imagePath),
                                fit: BoxFit.fill)
                            : const SizedBox())),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(7),
                width: MediaQuery.of(context).size.width,
                color: Colors.black45,
                child: Text("Update Profile Picture",
                    style: themeData.textTheme.bodyText2))
          ],
        ),
      ),
    );
  }
}
