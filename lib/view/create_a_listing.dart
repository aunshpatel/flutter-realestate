import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import '../consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

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
  int forSaleOrRent = 2, bedrooms = 0, parkingSpaces = 0;
  String listingName = '', description='', address='';
  double regularPrice = 0.0, discountedPrice = 0.0, bathrooms = 0.0;
  bool isDiscountAvailable = false;
  String interiorOfHouse = 'Furnished';
  final picker = ImagePicker();
  File? _image;
  bool uploading = false, isUploadButtonDisabled = false;
  var urlOfImageUploaded = [];
  var pickedImages;
  final ScrollController _scrollController = ScrollController();
  var items = [
    'Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  startUpload(bool isUploading){
    setState(() {
      uploading = isUploading;
    });
  }

  Future getPhotoFromGallery() async {
    pickedImages = await picker.pickMultiImage(imageQuality: 100);
    if(pickedImages.length > 0 && pickedImages.length<=6){
      print("pickedImages.length 1: ${pickedImages.length}");
      setState(() async {
        if (pickedImages != null) {
          for(int i=0; i<pickedImages?.length; i++){
            _image = File(pickedImages[i].path);
            print("_image$i: ${_image?.path}");

            startUpload(true);
            Reference ref = FirebaseStorage.instance.ref().child(
              Path.basename(_image!.path)
            );
            UploadTask uploadTask = ref.putFile(_image!);
            TaskSnapshot snapshot = await uploadTask.whenComplete(() {
              print('New picture uploaded');
              startUpload(false);
            });
            var uploadedImageLink = await snapshot.ref.getDownloadURL();
            setState(() {
              urlOfImageUploaded.add(uploadedImageLink);
            });
            print("urlOfImageUploaded:$urlOfImageUploaded, its length is:${urlOfImageUploaded.length}");
            if(urlOfImageUploaded.length == 6){
              isUploadButtonDisabled = true;
            }
            print("isUploadButtonDisabled:$isUploadButtonDisabled");
          }
        } else {
          print('No image selected.');
        }
      });
    }
    else{
      commonAlertBox(context, 'WARNING!', 'You can only upload upto 6 images!');
    }
  }

  Future photoFromCamera() async {
    pickedImages = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() async {
      if (pickedImages != null) {
        _image = File(pickedImages.path);
        print("_image: ${_image?.path}");
        startUpload(true);
        Reference ref = FirebaseStorage.instance.ref().child(
            Path.basename(_image!.path)
        );
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {
          print('New picture uploaded');
          startUpload(false);
        });
        var uploadedImageLink = await snapshot.ref.getDownloadURL();
        setState(() {
          urlOfImageUploaded.add(uploadedImageLink);
        });
        print("urlOfImageUploaded:$urlOfImageUploaded, its length is:${urlOfImageUploaded.length}");
        if(urlOfImageUploaded.length == 6){
          isUploadButtonDisabled = true;
        }
        print("isUploadButtonDisabled:$isUploadButtonDisabled");
      } else {
        print('No image selected.');
      }
    });
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
                  style: TextButton.styleFrom(
                    backgroundColor: kLightTitleColor,
                  ),
                  child: const Text('Gallery', style: kWhiteBoldTextStyle),
                ),
                TextButton(
                  onPressed: () {
                    photoFromCamera();
                    Navigator.of(context).pop();
                  },
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

  deletePhoto(String photoURL, int index){
    print('photoURL:$photoURL');
    deletePhotoConfirmation(photoURL, index);
  }

  Future<void> deletePhotoConfirmation(String photoURL, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WARNING!', style: kSideMenuDarkTextStyle),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: const Column (
                children: <Widget>[
                  Text('Are you sure you want to delete the image?', style: kLightSemiBoldTextStyle),
                ],
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('YES', style: TextStyle(color: kDarkTitleColor),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    var deletedImage = FirebaseStorage.instance.refFromURL(photoURL!);
                    deletedImage.delete().whenComplete(() {
                      setState(() {
                        urlOfImageUploaded.removeAt(index);
                        if(urlOfImageUploaded.length < 6){
                          isUploadButtonDisabled = false;
                        }
                      });
                    });
                  },
                ),
                TextButton(
                  child: const Text('NO', style: TextStyle(color: kDarkTitleColor),),
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
          actions: <Widget>[ ],
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
          child: uploading == true ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text('Uploading Photo(s)'),
                ],
              )
            ),
          ) :
          Padding(
            padding:  const EdgeInsets.fromLTRB(10, 24, 10, 24),
            child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 17.5,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //Listing Name
                            TextField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              onChanged:(value){
                                setState(() {
                                  listingName = value;
                                });
                              },
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
                              onChanged:(value){
                                setState(() {
                                  description = value;
                                });
                              },
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
                              onChanged:(value){
                                setState(() {
                                  address = value;
                                });
                              },
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
                                          groupValue: forSaleOrRent,
                                          onChanged: (int? value) {
                                            setState(() {
                                              forSaleOrRent = value!;
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
                                          groupValue: forSaleOrRent,
                                          onChanged: (int? value) {
                                            setState(() {
                                              forSaleOrRent = value!;
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
                              decoration: forSaleOrRent == 1 ? listingInputDecoration('Regular Price',) : listingInputDecoration('Regular Rent',),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            //Listing Discounted Price
                            if (isDiscountAvailable) ...[
                              TextField(
                                controller: discountedPriceController,
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                onChanged:(value){
                                  setState(() {
                                    discountedPrice = value as double;
                                  });
                                },
                                style: kSemiBoldRegularStyle,
                                decoration: forSaleOrRent == 1 ? listingInputDecoration('Discounted Price',) : listingInputDecoration('Discounted Rent',),
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
                              onChanged:(value){
                                setState(() {
                                  bedrooms = value as int;
                                });
                              },
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
                              onChanged:(value){
                                setState(() {
                                  bathrooms = value as double;
                                });
                              },
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
                              onChanged:(value){
                                setState(() {
                                  parkingSpaces = value as int;
                                });
                              },
                              style: kSemiBoldRegularStyle,
                              decoration: listingInputDecoration('Parking Spot(s)',),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            //Dropdown
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton(
                                value: interiorOfHouse,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    interiorOfHouse = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        flex: 4,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             MaterialButton(
                              onPressed: isUploadButtonDisabled == true ? () => {
                                commonAlertBox(context, 'WARNING!', 'You can not upload more than 6 images.')
                              } : photoSelector,
                              color: kDarkTitleColor,
                              child: const Text('Upload Photos',style: kWhiteBoldRegularText,),
                            ),

                            if(urlOfImageUploaded.isNotEmpty || urlOfImageUploaded!=null) ...[
                              const SizedBox(height:10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height - 220,
                                    child: Scrollbar(
                                      thickness: 10,
                                      controller: _scrollController,
                                      child: ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(context)
                                            .copyWith(scrollbars: false),
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          itemCount: urlOfImageUploaded.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(
                                              padding: const EdgeInsets.only(top:6, bottom: 6),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    urlOfImageUploaded[index],
                                                    height: 100,
                                                  ),
                                                  TextButton(
                                                    onPressed: () => {
                                                      deletePhoto(urlOfImageUploaded[index], index)
                                                    },
                                                    child: const Text('Delete Image',style: kRedBoldRegularText),
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]
                          ],
                        )
                      )
                    ]
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  RoundedButton(
                    colour:kDarkTitleColor,
                    title:'Create New Listing',
                    onPress:() {
                    },
                  ),
                ],
              )
          ),
        ),
      )
    );
  }
}