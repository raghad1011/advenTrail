import 'package:cloud_firestore/cloud_firestore.dart';

class TripsModel {
   String id;
  final String name;
  final double? price;
  final String description;
  final String location;
  final GeoPoint trailRoute;
  final String difficulty;
  final String duration;

  // final String imageUrl;
  final String? status;
  final bool? isDeleted;

  TripsModel({
    required this.id,
    required this.name,
    this.price,
    required this.description,
    required this.location,
    required this.trailRoute,
    required this.difficulty,
    required this.duration,
    // required this.imageUrl,
    this.status,
    this.isDeleted,
  });

  // Constructor for initializing default values
  // factory TripsModel.init() => TripsModel(
  //       id: "",
  //       name: '',
  //       price: 0.0,
  //       location: '',
  //       trailRoute: GeoPoint(0, 0),
  //       // imageUrl: "",
  //       isDeleted: false,
  //       status: '',
  //       description: '',
  //       difficulty: '',
  //       duration: '',
  //     );

  // Convert from JSON
  factory TripsModel.fromJson(Map<String, dynamic> json) => TripsModel(
        id: json['id'] ?? "",
        name: json['name'],
        price: json['price'],
        description: json['description'],
        location: json['location'],
        trailRoute: json['trailRoute'],
        difficulty: json['difficulty'],
        duration: json['duration'],
        // imageUrl: json['imageUrl'],
        status: json['status'],
        isDeleted: json['isDeleted'],
      );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['location'] = location;
    data['trailRoute'] = trailRoute;
    data['difficulty'] = difficulty;
    data['duration'] = duration;
    // data['imageUrl']= imageUrl;
    data['status'] = status;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
