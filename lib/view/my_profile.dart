import 'dart:io';

import 'package:flutter/material.dart';
import 'package:realestate/models/user_model.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

import '../controllers/user_controller.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _image;
  bool uploading = false;
  final picker = ImagePicker();
  var profilePic = prefs!.getString('avatarImage');
  var newProfilePic;
  var urlOfImageUploaded;
  String email='', username='', password='';

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  // @override
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

  startUpload(bool isUploading){
    setState(() {
      uploading = isUploading;
    });
  }

  Future getPhotoFromGallery() async {
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        startUpload(true);
        if (_image != null) {
          // Reference ref = FirebaseStorage.instance.ref().child(Path.basename(_image!.path));
          Reference ref = FirebaseStorage.instance.ref().child(Path.basename(_image!.path));
          UploadTask uploadTask = ref.putFile(_image!);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {
              print('New profile picture uploaded');
              startUpload(false);
          });
          urlOfImageUploaded = await snapshot.ref.getDownloadURL();
          newProfilePic = urlOfImageUploaded;
          var deletedImage = FirebaseStorage.instance.refFromURL(profilePic!);
          deletedImage.delete().whenComplete(() {
            print('Old profile picture deleted');
            profilePic = urlOfImageUploaded;
          });
          prefs.setString('avatarImage', urlOfImageUploaded);
        }
        updateProfile(username,email, password, newProfilePic);
      } else {
        print('No image selected.');
      }
    });
  }

  Future photoFromCamera() async {
    //final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        startUpload(true);
        if (_image != null) {
          Reference ref = FirebaseStorage.instance.ref().child(Path.basename(_image!.path));
          UploadTask uploadTask = ref.putFile(_image!);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {
            print('New profile picture uploaded');
            startUpload(false);
          });
          urlOfImageUploaded = await snapshot.ref.getDownloadURL();
          newProfilePic = urlOfImageUploaded;
          var deletedImage = FirebaseStorage.instance.refFromURL(profilePic!);
          deletedImage.delete().whenComplete(() {
            print('Old profile picture deleted');
            profilePic = urlOfImageUploaded;
          });
          prefs.setString('avatarImage', urlOfImageUploaded);
        }
        updateProfile(username,email, password, newProfilePic);
      } else {
        print('No image selected.');
      }
    });
  }

  Future updateProfile(String uname, String email, String pwd, String profilePic) async {

    final updatedUser = UserUpdate(username: uname, email: email, password: pwd, avatar:profilePic);
    final success = await UserController.updateUser(updatedUser);
    if(success == true){
      updateDialogBox('Congratulations!', 'Your profile has been updated successfully!');
    } else{
      dialogBox('Warning!','Your profile did not update!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
        body: uploading == false ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: photoSelector,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        urlOfImageUploaded != null ? Image.network(
                          urlOfImageUploaded,
                          height: 100,
                        ) : Image.network(
                          profilePic!,
                          height: 100,
                        ),
                      ],
                    )
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
        ) :
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kLightTitleColor),
            backgroundColor: Colors.transparent,
            strokeWidth: 5,
            // semanticsLabel: 'Uploading...',
            // strokeAlign: 1,
          ),
        ),
      )
    );
  }

  Future<void> photoSelector() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text('Select A ', style: kSideMenuLightTextStyle),
              Text('Photo Source', style: kSideMenuDarkTextStyle)
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    getPhotoFromGallery();
                    Navigator.of(context).pop();
                  },
                  // onPressed: getPhotoFromGallery,
                  style: TextButton.styleFrom(
                    backgroundColor: kLightTitleColor,
                  ),
                  child: const Text('Gallery', style: kWhiteBoldTextStyle),
                ),
                // SizedBox(width: 12,),
                TextButton(
                  onPressed: () {
                    photoFromCamera();
                    Navigator.of(context).pop();
                  },
                  // onPressed: photoFromCamera,
                  style: TextButton.styleFrom(
                    backgroundColor: kDarkTitleColor,
                  ),
                  child: const Text('Photo', style: kWhiteBoldTextStyle),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Cancel', style: TextStyle(color: kDarkTitleColor),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
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

  Future<void> dialogBox(String title, String bodyText) async {
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

  Future<void> updateDialogBox(String title, String bodyText) async {
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
                setState(() {

                });
              },
            ),
          ],
        );
      },
    );
  }
}
