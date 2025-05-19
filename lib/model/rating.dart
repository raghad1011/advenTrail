import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String userId;
  final String tripId;
  final double rating;
  final String? comment;
  final Timestamp date;

  RatingModel({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.rating,
    this.comment,
    required this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json, String id) {
    return RatingModel(
      id: id,
      userId: json['userId'],
      tripId: json['tripId'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tripId': tripId,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}
