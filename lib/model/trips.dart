import 'package:cloud_firestore/cloud_firestore.dart';

class TripsModel {
  String id;
  String? tripName;
  GeoPoint? location;
  String? image;
  double? price;
  String? status;
  bool? isDeleted;

  // Default constructor
  TripsModel({
    required this.id,
    required this.tripName,
    this.location,
    this.image,
    this.price,
    this.status,
    this.isDeleted,
  });

  // Constructor for initializing default values
  factory TripsModel.init() => TripsModel(
    id: "",
       tripName:'' ,
       location: GeoPoint(0, 0),
       price: 0.0,
       image: "",
       isDeleted: false,
       status: '',
  );

  // Convert from JSON
 factory  TripsModel.fromJson(Map<String, dynamic> json) => TripsModel (
    id : json['id'] ??"",
    tripName : json['tripName'],
    location : json['location'],
    image : json['image'],
    status : json['status'],
    price : (json['price'] ?? 0.0).toDouble(),
    isDeleted : json['isDeleted'] ?? false,
  );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'tripName': tripName,
      'location': location,
      'image': image,
      'status': status,
      'price': price,
      'isDeleted': isDeleted,
    };
  }
}
