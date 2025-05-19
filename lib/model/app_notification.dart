import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String userId;
  final String title;
  final String message;
  final String tripId;
  final String type;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.tripId,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return NotificationModel(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      tripId: json['tripId'] ?? '',
      type: json['type'] ?? 'info',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'tripId': tripId,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}
