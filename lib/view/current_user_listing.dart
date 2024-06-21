import 'package:flutter/material.dart';
import 'package:realestate/view/widgets/side_drawer.dart';

import '../api.dart';
import '../consts.dart';
class CurrentUserListings extends StatefulWidget {
  const CurrentUserListings({super.key});

  @override
  State<CurrentUserListings> createState() => _CurrentUserListingsState();
}

class _CurrentUserListingsState extends State<CurrentUserListings> {
  var currentUserListings = [];
  @override
  void initState() {
    super.initState();
    getListings();
  }

  getListings() async{
    final currentUserListingsData = await individualUserListing();
    setState(() {
      currentUserListings = currentUserListingsData;
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
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
              Text('Listings', style:TextStyle(color: kDarkTitleColor),),
            ],
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                currentUserListings.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height:440,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(4),
                            itemCount: currentUserListings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Card(
                                    child: SizedBox(
                                      height: 400,
                                      width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.network(currentUserListings[index]['imageUrls'][0], height: 80,),
                                              Text(currentUserListings[index]['name'], style: kHomePagePropertyTitle),
                                              Text(currentUserListings[index]['address'], style:kHomePagePropertyDesc),
                                              Text(currentUserListings[index]['description'], style:kHomePagePropertyDesc),
                                              Text('${currentUserListings[index]['bedrooms']} bedrooms, ${currentUserListings[index]['bathrooms']} bathrooms', style:kHomePagePropertyDesc),
                                              currentUserListings[index]['discountPrice'] > 0 ? Row(
                                                children: [
                                                  Text('\u0024 ${currentUserListings[index]['regularPrice']}', style:kHomePagePropertyDescStrike,),
                                                  Text(' \u0024 ${currentUserListings[index]['discountPrice']}', style:kHomePagePropertyDesc)
                                                ],
                                              ) : Text('\u0024 ${currentUserListings[index]['regularPrice']}', style:kHomePagePropertyDesc),
                                              Text(currentUserListings[index]['furnished'], style:kHomePagePropertyDesc),
                                            ],
                                          )
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                          )
                        ),
                      ],
                    )
                  ),
                ) : SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: const Center(child: Text("You Have No Listings", style: TextStyle(fontSize: 30, color: kDarkTextColor),),)
                )
              ],
            ),
          ),
        )
      )
    );
  }
}
