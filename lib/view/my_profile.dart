import 'dart:io';

import 'package:flutter/material.dart';
import 'package:realestate/models/user_model.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import 'package:path/path.dart' as Path;

import '../controllers/user_controller.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _image;
  final picker = ImagePicker();
  var profilePic = prefs!.getString('avatarImage');
  String email='', username='', password='';

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  loadDetails() {
    usernameController.text = prefs!.getString('username')!;
    username = prefs!.getString('username')!;
    emailController.text = prefs!.getString('email')!;
    email = prefs!.getString('email')!;
    passwordController.text = prefs!.getString('password')!;
    password = prefs!.getString('password')!;
  }

  Future getPhotoFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future photoFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future updateProfile(String uname, String email, String pwd, String profilePic) async {

    final updatedUser = UserUpdate(username: uname, email: email, password: pwd, avatar:profilePic);
    print("updatedUser:$updatedUser");
    final success = await UserController.updateUser(updatedUser);
    print("update successful: $success");
    if(success == true){
      updateDialog('Congratulations!', 'Your profile has been updated successfully!');
    } else{
      updateDialog('Warning!','Your profile did not update!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      drawer: const SideDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: kDarkTitleColor,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[

        ],
        centerTitle: true,
        title: const Wrap(
          children: [
            Text('My ', style:TextStyle(color: kLightTitleColor),),
            Text('Profile', style:TextStyle(color: kDarkTitleColor),),
          ],
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: photoSelector,
                      child: Image.network(
                        profilePic!,
                        height: 100,
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent)
                  ),
                  const SizedBox(height:40),
                  TextField(
                    controller: usernameController,
                    // readOnly: true,
                    onChanged:(value){
                      setState(() {
                        username = value;
                      });
                    },
                    style: const TextStyle(color: kLightTitleColor),
                    decoration: emailInputDecoration('Username',),
                  ),
                  const SizedBox(height:40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    onChanged:(value){
                      setState(() {
                        email = value;
                      });
                    },
                    style: const TextStyle(color: kLightTitleColor),
                    decoration: emailInputDecoration('Email',),
                  ),
                  const SizedBox(height:40),
                  TextField(
                    controller: passwordController,
                    obscureText: _passwordVisible == false ? true : false,
                    readOnly: true,
                    onChanged:(value){
                      setState(() {
                        password = value;
                      });
                    },
                    style: const TextStyle(color: kThemeBlueColor),
                    decoration: passwordInputDecoration(
                        'Enter your password',
                        _passwordVisible,
                            (){
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }
                    ),
                  ),
                  const SizedBox(height:40),
                  RoundedButton(
                    colour:kDarkTitleColor,
                    title:'Update',
                    onPress:() {
                      updateProfile(username,email, password, profilePic!);
                    },
                  ),
                  const SizedBox(height:10),
                  RoundedButton(
                    colour:kDarkTitleColor,
                    title:'Logout',
                    onPress:() {
                      setState(() async {
                        isLoggedIn = false;
                        prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', isLoggedIn);
                        prefs.setString('email', '');
                        prefs.setString('username', '');
                        prefs.setString('password', '');
                        prefs.setString('avatarImage', '');
                        currentUserID = '';
                        token = '';
                        logoutMessage();
                      });
                      // Navigator.pushNamed(context, '/main_screen');
                    },
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<void> photoSelector() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('Select A ', style: kSideMenuLightTextStyle),
              Text('Photo Source', style: kSideMenuDarkTextStyle)
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('Gallery', style: kWhiteBoldTextStyle),
                onPressed: () {
                  getPhotoFromGallery();
                },
                style: TextButton.styleFrom(
                  backgroundColor: kLightTitleColor,
                ),
              ),
              TextButton(
                child: const Text('Photo', style: kWhiteBoldTextStyle),
                onPressed: () {
                  photoFromCamera();
                },
                style: TextButton.styleFrom(
                  backgroundColor: kDarkTitleColor,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: kDarkTitleColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  logoutMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Successful!', style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have logged out successfully!', style: TextStyle(color: kLightTitleColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kLightTitleColor),),
              onPressed: () {
                Navigator.pushNamed(context, '/main_screen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateDialog(String title, String bodyText) async {
    // String AlertText = bodyText;
    // String AlertTitle = title;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(bodyText, style: TextStyle(color: kLightTitleColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kLightTitleColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
