import 'package:adver_trail/component/custom_text_field.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => ManageUsersScreenState();
}

class ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseService firebaseService = FirebaseService();
  late Future<QuerySnapshot> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = firebaseService.getAllUsers();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void userInfo(BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'User Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              buildInfoCard('Name', userData['name']),
              SizedBox(height: 10),
              buildInfoCard('Phone', userData['phone']),
              SizedBox(height: 10),
              buildInfoCard('Email', userData['email']),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF556B2F), width: 1.5),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: value,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showUserOptions(
      BuildContext context, String userId, Map<String, dynamic> userData) {
    nameController.text = userData['name'] ?? '';
    phoneController.text = userData['phone'] ?? '';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Edit User",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.white,
                labelText: 'User Name',
                hintText: userData['User name'] ?? 'User Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF556B2F)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF556B2F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF556B2F), width: 2),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Phone Number',
                hintText: userData['phone'] ?? 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF556B2F)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF556B2F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF556B2F), width: 2),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF556B2F),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                updateUser(userId);
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ]),
        );
      },
    );
  }

  void updateUser(String userId) async {
    Map<String, dynamic> updatedUserData = {
      'name': nameController.text,
      'phone': phoneController.text,
    };

    await firebaseService.updateUser(userId, updatedUserData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User updated successfully!')),
    );

    setState(() {
      usersFuture = firebaseService.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EEDC),
      appBar: AppBar(
        title: Text("Manage Users", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D8B5D),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;

              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => showUserOptions(context, user.id, userData),
                      backgroundColor: Color(0xFFB7C9A8),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (_) => showDeleteConfirmationDialog(context, user.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    title: Text(
                      userData['name'] ?? 'No Name',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userData['email'] ?? 'No Email',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () => userInfo(context, user.data() as Map<String, dynamic>),
                  ),
                ),
              );
            },
          );
        },
      ),
    );


  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String tripId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await firebaseService.deleteUser(tripId);
                if (context
                    .findAncestorStateOfType<ManageUsersScreenState>() !=
                    null) {
                  context
                      .findAncestorStateOfType<ManageUsersScreenState>()!
                      .setState(() {});
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

