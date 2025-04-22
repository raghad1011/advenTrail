import 'package:cloud_firestore/cloud_firestore.dart';

class TripsModel {
  String id;
  final String name;
  final int? price;
  final String category;
  final String? description;
  final String location;
  final GeoPoint trailRoute;
  final String difficulty;
  final String accessibility;
  final String distance;
  final String duration;
  final String imageUrl;
  final Timestamp? tripDate;
  final String? status;
  final int? maxGuests;


  TripsModel({
    required this.id,
    required this.name,
    this.price,
    required this.category,
    this.description,
    required this.location,
    required this.trailRoute,
    required this.difficulty,
    required this.accessibility,
    required this.distance,
    required this.duration,
    required this.imageUrl,
     this.tripDate,
    this.status,
     this.maxGuests,
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
        category: json['category'],
        description: json['description'],
        location: json['location'],
        trailRoute: json['trailRoute'],
        difficulty: json['difficulty'],
        accessibility: json['accessibility'],
        distance: json['distance'],
        duration: json['duration'],
        imageUrl: json['imageUrl'],
        tripDate: json['tripDate'],
        status: json['status'],
        maxGuests: json['maxGuests'] ?? 5 ,
      );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['price'] = price;
    data['category'] = category;
    data['description'] = description;
    data['location'] = location;
    data['trailRoute'] = trailRoute;
    data['difficulty'] = difficulty;
    data['accessibility'] = accessibility;
    data['distance'] = distance;
    data['duration'] = duration;
    data['imageUrl'] = imageUrl;
    data['tripDate'] = tripDate;
    data['status'] = status;
    data['maxGuests'] = maxGuests;
    return data;
  }
}
