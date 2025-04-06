import 'package:adver_trail/model/trips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel{
  String? id;
  TripsModel? trip;
  DocumentReference? tripId;
  String? userName;
  double? price;
  String? status;
  Timestamp? date;
  bool? is_deleted;

  BookModel({
    this.id,
    required this.tripId,
    this.trip,
    this.userName,
    this.price,
    this.status,
    this.is_deleted,
    this.date
  });

  BookModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    trip = json['trip'];
    tripId = json['tripId'];
    userName = json['userName'];
    status = json['status'];
    price = json['price'];
    is_deleted = json['is_deleted'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip'] = trip;
    data['tripId'] = tripId;
    data['userName'] = userName;
    data['status'] = status;
    data['price'] = price;
    data['is_deleted'] = is_deleted;
    data['date'] = date;
    return data;
  }

}