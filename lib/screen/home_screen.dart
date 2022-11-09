import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile/screen/admin_edit_user_screen.dart';
import 'package:user_profile/screen/introduction.dart';
import 'package:user_profile/service/database/database.dart';
import 'package:user_profile/service/model/user_details.dart';
import 'package:user_profile/utils/widgets/button_widget.dart';
import 'package:user_profile/utils/widgets/common_utils_widget.dart';
import '../preferences/preference_manager.dart';
import '../utils/widgets/circular_indicator_widget.dart';

class HomeScreen extends StatefulWidget {
  final String? mobileOrMail;
  final String? password;
  final bool? bAdmin;
  final UserDetails? userInfo;
  const HomeScreen({
    this.mobileOrMail,
    this.password,
    this.bAdmin,
    this.userInfo,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  late ThemeData themeData;

  bool isLoading = false;

  String name = '';
  String password = '';
  String email = '';
  String mobileNumber = '';
  String imagePath = '';
  List<UserDetails> userList = [];
  List<UserDetails> deletedList = [];

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<UserDetails> suggestionList = [];

  TextEditingController searchDistributorController = TextEditingController();
  FocusNode searchDistributorFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    isLoading = true;
    if (widget.bAdmin!) {
//
      userList = await DataBase.instance.getData();

      suggestionList = userList;
    } else {
      //
      password = await PreferenceManager.instance.getPassword();
      email = await PreferenceManager.instance.getEmail();
      mobileNumber = await PreferenceManager.instance.getMobileNumber();
      name = await PreferenceManager.instance.getName();
      imagePath = await PreferenceManager.instance.getImageUrl();

      _passwordController.text = password;
      _emailController.text = email;
      _mobileNumberController.text = mobileNumber;
      _userNameController.text = name;
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return isLoading
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
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: widget.bAdmin!
                    ? const Text('USER LIST')
                    : const Text('USER PROFILE'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
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
                        widget.bAdmin! ? homeScreenUI() : userProfileUI(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget homeScreenUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'User List',
            style: themeData.textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          searchDistributorFilterTextField(),
          SingleChildScrollView(
            child: navigateCardUI(),
          ),
          deletedList.isNotEmpty
              ? Text(
                  'Removed List',
                  style: themeData.textTheme.subtitle1!
                      .copyWith(color: Colors.white),
                )
              : const SizedBox(),
          SingleChildScrollView(
            child: deletedListUi(),
          )
        ],
      ),
    );
  }

  Widget deletedListUi() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (UserDetails userInfo in deletedList) deletedCardUI(userInfo)
        ],
      ),
    );
  }

  Widget deletedCardUI(UserDetails userInfo) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        tileColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 50,
                height: 50,
                child: userInfo.imagePath.isEmpty
                    ? const Center(child: Text('NA/-'))
                    : Image.file(File(userInfo.imagePath), fit: BoxFit.fill)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.userName,
                    style: themeData.textTheme.subtitle1!,
                  ),
                  Text(
                    userInfo.email,
                    style: themeData.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditUserScreen(
                            userInfo: userInfo,
                          )));

                  getData();
                },
                child: const Icon(Icons.navigate_next)),
          ],
        ),
      ),
    );
  }

  Widget navigateCardUI() {
    return SizedBox(
      height: deletedList.isNotEmpty ? 250 : MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (UserDetails userInfo in suggestionList) cardUI(userInfo)
          ],
        ),
      ),
    );
  }

  Widget cardUI(UserDetails userInfo) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        tileColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 50,
                height: 50,
                child: userInfo.imagePath.isEmpty
                    ? const Center(child: Text('NA/-'))
                    : Image.file(File(userInfo.imagePath), fit: BoxFit.fill)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.userName,
                    style: themeData.textTheme.subtitle1!,
                  ),
                  Text(
                    userInfo.email,
                    style: themeData.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () async {
                  deletedList.add(userInfo);
                  suggestionList.remove(userInfo);
                  userList.remove(userInfo);
                  setState(() {});
                },
                child: const Icon(Icons.delete)),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditUserScreen(
                            userInfo: userInfo,
                          )));

                  getData();
                },
                child: const Icon(Icons.navigate_next)),
          ],
        ),
      ),
    );
  }

  Widget searchDistributorFilterTextField() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: ListTile(
        tileColor: Colors.grey,
        leading: const Icon(Icons.search),
        title: TextFormField(
          focusNode: searchDistributorFocusNode,
          controller: searchDistributorController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            filled: false,
            isDense: true,
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            hintText: "Search by name/mailId/phone here...",
          ),
          onChanged: (value) => {_runFilter(value)},
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) async {
    if (enteredKeyword.isEmpty) {
      userList;
      setState(() {});
      return;
    }

    var suggestions = userList.where(
      (element) {
        var name = element.userName.toLowerCase();
        var email = element.email.toLowerCase();
        var phone = element.mobile.toLowerCase();
        var input = enteredKeyword.toLowerCase();
        return name.contains(input) ||
            email.contains(input) ||
            phone.contains(input);
      },
    ).toList();

    setState(() {
      if (enteredKeyword.isNotEmpty) {
        suggestionList = suggestions;
      }
    });
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
            textInputUI(_userNameController, 'Name'),
            const SizedBox(height: 15),
            textInputUI(_emailController, 'Email'),
            const SizedBox(height: 15),
            textInputUI(_mobileNumberController, 'Mobile Number'),
            const SizedBox(height: 15),
            textInputUI(_passwordController, 'Password'),
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
        await PreferenceManager.instance.setImage(imagePath);
      } else {
        bFilePicked = true;
        await PreferenceManager.instance.setImage(pickedFile!.path);
      }
      await PreferenceManager.instance.setName(_userNameController.text);

      await PreferenceManager.instance.setPassword(_passwordController.text);

      await PreferenceManager.instance
          .setMobileNumber(_mobileNumberController.text);
      await PreferenceManager.instance.setEmail(_emailController.text);

      UserDetails user = UserDetails(
          imagePath: pickedFile == null ? imagePath : pickedFile!.path,
          userName: _userNameController.text.isEmpty
              ? name
              : _userNameController.text,
          email: _emailController.text.isEmpty ? email : _emailController.text,
          mobile: _mobileNumberController.text.isEmpty
              ? mobileNumber
              : _mobileNumberController.text,
          password: _passwordController.text.isEmpty
              ? password
              : _passwordController.text,
          userId: 2);

      isLoading = false;
      bool status = await DataBase.instance.insertData(user);
      setState(() {});
      if (status) {
        CommonUtils.instance
            .showSnackBar(context, 'Profile Updated Successfully !', "P");
      } else {
        CommonUtils.instance.showSnackBar(context, " Please try again.", "N");
      }
    }
  }

  Widget textInputUI(TextEditingController? controller, String labelText) {
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
        labelText: labelText,

        //  hintText: text,
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
                      : Image.file(File(imagePath), fit: BoxFit.fill),
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
