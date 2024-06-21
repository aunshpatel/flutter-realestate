import 'package:flutter/material.dart';

import '../../consts.dart';
class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: kBackgroundColor,
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              //Image
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: kBlackColor,
                    )
                  )
                ),
                child: SizedBox(
                    height: 200,
                    child: Image.asset('images/realestate-high-resolution-logo.jpeg')
                )
              ),
              //Home Screen
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: kBlackColor,
                    )
                  )
                ),
                child: ListTile(
                  title: const Wrap(
                    children: [
                      Text('Home ', style:kSideMenuLightTextStyle),
                      Text('Screen', style:kSideMenuDarkTextStyle,),
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/main_screen');
                  },
                ),
              ),
              //if user is logged in
              if (isLoggedIn) ...[
                //My Listings
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: kBlackColor,
                          )
                      )
                  ),
                  child: ListTile(
                    title: const Wrap(
                      children: [
                        Text('My ', style:kSideMenuLightTextStyle),
                        Text('Listings', style:kSideMenuDarkTextStyle,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/current_user_listing');
                    },
                  ),
                ),
                //Create New Listing
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: kBlackColor,
                      )
                    )
                  ),
                  child: ListTile(
                    title: const Wrap(
                      children: [
                        Text('Create ', style:kSideMenuLightTextStyle),
                        Text('New ', style:kSideMenuLightTextStyle),
                        Text('Listing', style:kSideMenuDarkTextStyle,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/create_a_listing');
                    },
                  ),
                ),
                //My Profile
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: kBlackColor,
                          )
                      )
                  ),
                  child: ListTile(
                    title: const Wrap(
                      children: [
                        Text('My ', style:kSideMenuLightTextStyle),
                        Text('Profile', style:kSideMenuDarkTextStyle,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/profile_page');
                    },
                  ),
                ),
              ],
              const SizedBox(),
              //if user is not logged in
              if (!isLoggedIn) ...[
                //Login
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: kBlackColor,
                          )
                      )
                  ),
                  child: ListTile(
                    title: const Wrap(
                      children: [
                        Text('Log', style:kSideMenuLightTextStyle),
                        Text('in', style:kSideMenuDarkTextStyle,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/login_screen');
                    },
                  ),
                ),
                //My Profile
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: kBlackColor,
                          )
                      )
                  ),
                  child: ListTile(
                    title: const Wrap(
                      children: [
                        Text('Regist', style:kSideMenuLightTextStyle),
                        Text('ration', style:kSideMenuDarkTextStyle,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/registration_screen');
                    },
                  ),
                )
              ],
              const SizedBox(),
            ],
          ),
        )
    );
  }
}
