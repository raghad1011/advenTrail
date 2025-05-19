import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

import '../../model/app_notification.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    required String tripId,
    required String type,
  }) async {
    log("📨 Preparing to send notification to user: $userId, title: $title, message: $message, tripId: $tripId, type: $type");

    try {
      final docRef = await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'tripId': tripId,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      log("✅ Notification added successfully for user: $userId, doc ID: ${docRef.id}");
      return true;
    } catch (e, stackTrace) {
      log("❌ Failed to send notification for user: $userId, error: $e", error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool> sendTestNotification(BuildContext context) async {
    log("Running test notification for user: Wp3jqqSHp3RXsEbdLXOo2mApQVm2");
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      log("❌ No authenticated user for test notification");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No authenticated user. Please log in.')),
      );
      return false;
    }
    log("Authenticated user: ${currentUser.uid}");
    final success = await sendNotificationToUser(
      userId: 'Wp3jqqSHp3RXsEbdLXOo2mApQVm2',
      title: 'Trip Canceled',
      message: 'The trip "Dead Sea Hike" has been canceled due to weather.',
      tripId: 'djuNLMHUstw4vt7QSHv4',
      type: 'cancellation',
    );
    if (success) {
      log("✅ Test notification sent successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test notification sent successfully')),
      );
    } else {
      log("❌ Failed to send test notification");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send test notification')),
      );
    }
    return success;
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('notification'),
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await NotificationScreen.sendTestNotification(context);
              },
              child: Text('Send Test Notification'),
            ),
          ),
          Expanded(
            child: currentUserId == null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 300,
                    color: Color.fromARGB(124, 4, 0, 0),
                  ),
                  Text(
                    'please sign in to see notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Cairo',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: currentUserId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  log('Error fetching notifications: ${snapshot.error}', stackTrace: snapshot.stackTrace);
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 300,
                          color: Colors.red,
                        ),
                        Text(
                          'حدث خطأ أثناء جلب الإشعارات\nتأكد من إعدادات Firestore',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 300,
                          color: Color.fromARGB(124, 4, 0, 0),
                        ),
                        Text(
                          'لا توجد إشعارات حاليًا',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final notifications = snapshot.data!.docs
                    .map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    final formattedTime = notification.timestamp != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp)
                        : 'غير متوفر';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: notification.isRead ? Colors.white : Colors.grey[200],
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          notification.title.isNotEmpty ? notification.title : 'إشعار جديد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            color: const Color(0xFF7A0000),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              notification.message.isNotEmpty ? notification.message : 'لا يوجد محتوى',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'date: $formattedTime',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        leading: Icon(
                          notification.type == 'cancellation'
                              ? Icons.cancel
                              : notification.isRead
                              ? Icons.notifications
                              : Icons.notifications_active,
                          color: const Color(0xFF7A0000),
                          size: 30,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .doc(notification.id)
                                  .delete();
                              log('Notification deleted: ${notification.id}');
                            } catch (e, stackTrace) {
                              log('Error deleting notification: $e', error: e, stackTrace: stackTrace);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
