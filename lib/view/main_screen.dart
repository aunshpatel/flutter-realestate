import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import 'dart:core';
import '../api.dart';
import '../consts.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // var listingWithDiscount = [], listingForRent = [], listingForSale = [];

  @override
  void initState() {
    super.initState();
    getListings();
  }

  getListings() async{
    final listingForSaleData = await fetchSellListForShowing();
    final listingWithDiscountData = await fetchDiscountListForShowing();
    final listingForRentData = await fetchRentListForShowing();

    setState(() {
      listingForSale = listingForSaleData;
      listingWithDiscount = listingWithDiscountData;
      listingForRent = listingForRentData;
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
            Text('Home ', style:TextStyle(color: kLightTitleColor),),
            Text('Screen', style:TextStyle(color: kDarkTitleColor),),
          ],
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text("Find your next ", style: TextStyle(fontSize: 30, color: kDarkTextColor),),
                      Text("humble adobe ", style: TextStyle(fontSize: 30, color: kSilverTextColor),),
                      Text("with ease", style: TextStyle(fontSize: 30, color: kDarkTextColor),),
                    ],
                  ),
                )
              ),
              (listingForRent.isEmpty && listingWithDiscount.isEmpty && listingForSale.isEmpty) ? SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: const Center(child: Text("No Listings", style: TextStyle(fontSize: 30, color: kDarkTextColor),),)
                // child: Center(child: CircularProgressIndicator(),),
              ) : const SizedBox(height: 0,),

              //Expanded for properties with discount
              listingWithDiscount.isNotEmpty ? Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: SizedBox(
                  height:440,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text('Recent Properties With Discount', style: kSideMenuLightTextStyle,)
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(4),
                          itemCount: listingWithDiscount.length,
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
                                            Image.network(listingWithDiscount[index]['imageUrls'][0], height: 80,),
                                            Text(listingWithDiscount[index]['name'], style: kHomePagePropertyTitle),
                                            Text(listingWithDiscount[index]['address'], style:kHomePagePropertyDesc),
                                            Text(listingWithDiscount[index]['description'], style:kHomePagePropertyDesc),
                                            Text('${listingWithDiscount[index]['bedrooms']} bedrooms, ${listingWithDiscount[index]['bathrooms']} bathrooms', style:kHomePagePropertyDesc),
                                            listingWithDiscount[index]['discountPrice'] > 0 ? Row(
                                              children: [
                                                Text('\u0024 ${listingWithDiscount[index]['regularPrice']}', style:kHomePagePropertyDescStrike,),
                                                Text(' \u0024 ${listingWithDiscount[index]['discountPrice']}', style:kHomePagePropertyDesc)
                                              ],
                                            ) : Text('\u0024 ${listingWithDiscount[index]['regularPrice']}', style:kHomePagePropertyDesc),
                                            Text(listingWithDiscount[index]['furnished'], style:kHomePagePropertyDesc),
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
              ) : const SizedBox(height: 0,),

              //Expanded for properties for sale
              listingForSale.isNotEmpty ? Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: SizedBox(
                  height:440,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text('Recent Properties For Sale', style: kSideMenuLightTextStyle,)
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(4),
                          itemCount: listingForSale.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
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
                                              Image.network(listingForSale[index]['imageUrls'][0], height: 80,),
                                              Text(listingForSale[index]['name'], style: kHomePagePropertyTitle),
                                              Text(listingForSale[index]['address'], style:kHomePagePropertyDesc),
                                              Text(listingForSale[index]['description'], style:kHomePagePropertyDesc),
                                              Text('${listingForSale[index]['bedrooms']} bedrooms, ${listingForSale[index]['bathrooms']} bathrooms', style:kHomePagePropertyDesc),
                                              listingForSale[index]['discountPrice'] > 0 ? Row(
                                                children: [
                                                  Text('\u0024 ${listingForSale[index]['regularPrice']}', style:kHomePagePropertyDescStrike,),
                                                  Text(' \u0024 ${listingForSale[index]['discountPrice']}', style:kHomePagePropertyDesc)
                                                ],
                                              ) : Text('\u0024 ${listingForSale[index]['regularPrice']}', style:kHomePagePropertyDesc),
                                              Text(listingForSale[index]['furnished'], style:kHomePagePropertyDesc),
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
              ) : const SizedBox(height: 0,),

              //Expanded for properties for rent
              listingForRent.isNotEmpty ?  SizedBox(
                height:440,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text('Recent Properties For Rent', style: kSideMenuLightTextStyle,)
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        itemCount: listingForRent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
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
                                          Image.network(listingForRent[index]['imageUrls'][0], height: 80,),
                                          Text(listingForRent[index]['name'], style: kHomePagePropertyTitle),
                                          Text(listingForRent[index]['address'], style:kHomePagePropertyDesc),
                                          Text(listingForRent[index]['description'], style:kHomePagePropertyDesc),
                                          Text('${listingForRent[index]['bedrooms']} bedrooms, ${listingForRent[index]['bathrooms']} bathrooms', style:kHomePagePropertyDesc),
                                          listingForRent[index]['discountPrice'] > 0 ? Row(
                                            children: [
                                              Text('\u0024 ${listingForRent[index]['regularPrice']}', style:kHomePagePropertyDescStrike,),
                                              Text(' \u0024 ${listingForRent[index]['discountPrice']}', style:kHomePagePropertyDesc)
                                            ],
                                          ) : Text('\u0024 ${listingForRent[index]['regularPrice']}', style:kHomePagePropertyDesc),
                                          Text(listingForRent[index]['furnished'], style:kHomePagePropertyDesc),
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
              ) : const SizedBox(height: 0,),
            ],
          ),
        ),
      )
    );
  }
}
