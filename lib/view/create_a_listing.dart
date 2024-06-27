import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import '../consts.dart';

class CreateAListing extends StatefulWidget {
  const CreateAListing({super.key});

  @override
  State<CreateAListing> createState() => _CreateAListingState();
}

class _CreateAListingState extends State<CreateAListing> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController regularPriceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController bedroomsController = TextEditingController();
  TextEditingController bathroomsController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  int _selectedValue = 0;
  bool isDiscountAvailable = false;
  String dropdownvalue = 'Furnished';
  var items = [
    'Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

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
              Text('Create ', style:TextStyle(color: kLightTitleColor),),
              Text('A ', style:TextStyle(color: kLightTitleColor),),
              Text('Listing', style:TextStyle(color: kDarkTitleColor),),
            ],
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Name
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Name of Listing',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Description
                TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Description'),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Address
                TextField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Address',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Row for For sale/For rent radio button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                        title: const Text('For Sale', style: kSemiBoldRegularStyle,),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Radio(
                            value: 1,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          ),
                        )
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                        title: const Text('For Rent',style: kSemiBoldRegularStyle,),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Radio(
                            value: 2,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          ),
                        )
                      ),
                    ),
                  ],
                ),
                //Row for discount toggle
                Row(
                  children: [
                    Checkbox(
                      value: isDiscountAvailable,
                      activeColor: kLightTitleColor,
                      onChanged:(bool? newValue){
                        setState(() {
                          isDiscountAvailable = newValue!;
                        });
                      }
                    ),
                    const Text('Discount Available', style: kSemiBoldRegularStyle,),
                  ],
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Regular Price
                TextField(
                  controller: regularPriceController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  textInputAction: TextInputAction.done,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Regular Price',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Discounted Price
                if (isDiscountAvailable) ...[
                  TextField(
                    controller: discountedPriceController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    onChanged:(value){ },
                    style: kSemiBoldRegularStyle,
                    decoration: listingInputDecoration('Discounted Price',),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
                //Listing Bedrooms
                TextField(
                  controller: bedroomsController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  textInputAction: TextInputAction.done,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Bedrooms',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Bedrooms
                TextField(
                  controller: bathroomsController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  textInputAction: TextInputAction.done,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Bathrooms',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Listing Parking
                TextField(
                  controller: parkingController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  textInputAction: TextInputAction.done,
                  onChanged:(value){ },
                  style: kSemiBoldRegularStyle,
                  decoration: listingInputDecoration('Parking Spaces',),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                //Dropdown
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 17.5,
                ),
                RoundedButton(
                  colour:kDarkTitleColor,
                  title:'Create New Listing',
                  onPress:() {
                  },
                ),
                const SizedBox(height:20),
              ],
            ),
          ),
        ),
      )
    );
  }
}
