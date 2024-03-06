import 'package:flutter/material.dart';
import 'package:realestate/view/widgets/side_drawer.dart';

import '../consts.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Text('Profile Page')
          ],
        ),
      ),
    );
  }
}
