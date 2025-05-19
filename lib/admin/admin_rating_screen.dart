import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminRatingsScreen extends StatefulWidget {
  const AdminRatingsScreen({super.key});

  @override
  State<AdminRatingsScreen> createState() => _AdminRatingsScreenState();
}

class _AdminRatingsScreenState extends State<AdminRatingsScreen> {
  late Future<Map<String, List<Map<String, dynamic>>>> tripRatings;

  @override
  void initState() {
    super.initState();
    tripRatings = fetchTripRatingsGrouped();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchTripRatingsGrouped() async {
    final ratingSnapshot = await FirebaseFirestore.instance.collection('ratings').get();

    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var doc in ratingSnapshot.docs) {
      final data = doc.data();
      final tripId = data['tripId'];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(data['userId'])
          .get();
      final userName = userSnapshot.data()?['name'] ?? 'Unknown User';

      final tripSnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .get();
      final tripName = tripSnapshot.data()?['name'] ?? 'Unknown Trip';

      final entry = {
        'rating': (data['rating'] as num).toDouble(),
        'comment': data['comment'],
        'date': (data['date'] as Timestamp).toDate(),
        'userName': userName,
        'tripName': tripName,
      };

      grouped.putIfAbsent(tripId, () => []).add(entry);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Ratings")),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: tripRatings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final grouped = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries.map((entry) {
              final ratings = entry.value;
              final tripName = ratings.first['tripName'];
              final avg = (ratings.map((r) => r['rating'] as double).reduce((a, b) => a + b)) / ratings.length;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: avg >= 3.0 ? Colors.green[50] : Colors.red[50],
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    tripName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    '⭐ ${avg.toStringAsFixed(1)} / 5  •  ${ratings.length} ${ratings.length == 1 ? 'rating' : 'ratings'}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  children: ratings.map((r) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('👤 ${r['userName']}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text('⭐ ${r['rating']}'),
                            ],
                          ),
                          if (r['comment'] != null && r['comment'].toString().isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text('💬 ${r['comment']}'),
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text('📅 ${DateFormat.yMMMd().format(r['date'])}'),
                          ),
                          Divider(thickness: 1, height: 20),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}