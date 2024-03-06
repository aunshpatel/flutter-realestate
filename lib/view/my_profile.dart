import 'dart:io';

import 'package:flutter/material.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import 'package:image_picker/image_picker.dart';
import '../consts.dart';
import 'package:path/path.dart' as Path;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _image;
  final picker = ImagePicker();
  var profilePic = prefs!.getString('avatarImage');

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
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
      body: Padding(
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
            ],
          ),
        )
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
}
