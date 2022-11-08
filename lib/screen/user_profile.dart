import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile/screen/mobile_number_screen.dart';
import 'package:user_profile/screen/user_updated_profile_screen.dart';
import 'package:user_profile/service/database/database.dart';
import 'package:user_profile/service/model/user_details.dart';
import 'package:user_profile/utils/widgets/button_widget.dart';
import 'package:user_profile/utils/widgets/common_utils_widget.dart';

import '../preferences/preference_constants.dart';
import '../preferences/preference_manager.dart';
import '../utils/widgets/circular_indicator_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  late ThemeData themeData;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  //List<UserDetails> filterList = [];
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    isLoading = true;
//    filterList = await DataBase.instance.getUserDetailsList();
    _userIdController.text = '';
    // filterList.first.userId;
    _addressController.text = '';
    // filterList.first.address;
    _emailController.text = '';
    // filterList.first.email;
    _mobileNumberController.text = '';
    // filterList.first.mobile;
    _userNameController.text = '';
    // filterList.first.userName;
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
              title: const Text('SIGN UP'),
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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 5),
            profilePictureWidget(),
            const SizedBox(height: 15),
            textInputUI(_userIdController, 'User ID'),
            const SizedBox(height: 15),
            textInputUI(_userNameController, 'Name'),
            const SizedBox(height: 15),
            textInputUI(_emailController, 'Email'),
            const SizedBox(height: 15),
            textInputUI(_mobileNumberController, 'Mobile Number'),
            const SizedBox(height: 15),
            textInputUI(_addressController, 'Address'),
            const SizedBox(height: 15),
            ButtonWidget(text: 'UPDATE', onClicked: () => onClicked())
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
      //  isLoading = true;
      if (pickedFile == null) {
        bFilePicked = false;
        await PreferenceManager.instance.setImage('');
      } else {
        bFilePicked = true;
        await PreferenceManager.instance.setImage(pickedFile!.path);
      }
      await PreferenceManager.instance.setName(_userNameController.text);
      await PreferenceManager.instance.setUserId(_userIdController.text);
      await PreferenceManager.instance.setAddress(_addressController.text);

      await PreferenceManager.instance
          .setMobileNumber(_mobileNumberController.text);
      await PreferenceManager.instance.setEmail(_emailController.text);

      //  isLoading = false;
      String status = await DataBase.instance.postProfileUpdate();
      if (status == 'Profile Updated Successfully!.') {
        CommonUtils.instance.showSnackBar(context, status, "P");
      } else {
        CommonUtils.instance.showSnackBar(context, " Please try again.", "N");
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MobileNumberScreen()),
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
        // labelText: labelText,
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
                        : const SizedBox()
                    // : Image.memory(
                    //     base64Decode(filterList.first.imagePath),
                    //   ),
                    )),
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
