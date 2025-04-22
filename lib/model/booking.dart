import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel{
  String? id;
  DocumentReference? tripId;
  DocumentReference? userId;
  int? price;
  String? status;
  int? numberOfGuests;
  Timestamp? bookingDate;
  Timestamp? tripDate;
  bool? is_deleted;

  BookingModel({
    this.id,
    required this.tripId,
    this.userId,
    this.price,
    this.status,
    this.numberOfGuests,
    this.is_deleted,
    this.bookingDate,
    this.tripDate,
  });

  BookingModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    tripId = json['tripId'];
    userId = json['userId'];
    status = json['status'];
    numberOfGuests = json['numberOfGuests'];
    price = json['price'];
    is_deleted = json['is_deleted'];
    bookingDate = json['bookingDate'];
    tripDate = json['tripDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tripId'] = tripId;
    data['userId'] = userId;
    data['status'] = status;
    data['numberOfGuests'] = numberOfGuests;
    data['price'] = price;
    data['is_deleted'] = is_deleted;
    data['bookingDate'] = bookingDate;
    data['tripDate'] = tripDate;
    return data;
  }

}