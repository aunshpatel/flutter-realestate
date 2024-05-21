class IndividualListingController{
  final String name;
  final String description;
  final String address;
  final double regularPrice;
  final double discountPrice;
  final double bathrooms;
  final double bedrooms;
  final bool furnished;
  final double parking;
  final String type;
  final bool discount;
  final String imageUrls;
  final String userRef;

  IndividualListingController({required this.name, required this.description, required this.address, required this.regularPrice, required this.discountPrice, required this.bathrooms, required this.bedrooms, required this.furnished, required this.parking, required this.type, required this.discount, required this.imageUrls, required this.userRef});

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'description': description,
      'address': address,
      'regularPrice':regularPrice,
      'discountPrice': discountPrice,
      'bathrooms': bathrooms,
      'bedrooms':bedrooms,
      'furnished': furnished,
      'parking': parking,
      'type':type,
      'discount': discount,
      'imageUrls': imageUrls,
      'userRef': userRef,
    };
  }
}