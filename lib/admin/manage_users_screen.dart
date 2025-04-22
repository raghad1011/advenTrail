import 'package:adver_trail/component/custom_text_field.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
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
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${userData['name']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Phone: ${userData['phone']}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Email: ${userData['email']}',
                  style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
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
          padding: EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Edit User",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text("Name")),
                Expanded(
                    child: CustomTextField(
                  controller: nameController,
                  icon: Icons.person_2,
                  hintText: userData['name'] ?? 'Enter Name',
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text("Phone Number")),
                Expanded(
                    child: CustomTextField(
                  controller: phoneController,
                  icon: Icons.phone,
                  hintText: userData['phone'] ?? 'Enter Phone Number',
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  updateUser(userId);
                  Navigator.pop(context);
                },
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.brown),
                )),
          ]),
        );
      },
    );
  }

  void deleteUser(String userId) async {
    await firebaseService.deleteUser(userId);

    setState(() {
      usersFuture = firebaseService.getAllUsers();
    });
  }

  void updateUser(String userId) async {
    Map<String, dynamic> updatedUserData = {
      'name': nameController.text,
      'phone': phoneController.text,
    };

    await firebaseService.updateUser(userId, updatedUserData);

    setState(() {
      usersFuture = firebaseService.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users"),
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
            // Prevent overflow inside scrollable parent
            physics: NeverScrollableScrollPhysics(),
            // Disable the scroll in ListView (SingleChildScrollView handles it)
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => showUserOptions(context, user.id,
                          user.data() as Map<String, dynamic>),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => deleteUser(user.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    user['name'],
                    style:
                        TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user['email'],
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onTap: () => userInfo(
                      context, user.data() as Map<String, dynamic>),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
