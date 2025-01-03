import 'package:flutter/material.dart';
import '../component/profiletextfield.dart';
import '../component/dropdownfield.dart';
import '../component/datefield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? _selectedDate;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xff361C0B),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // الحل لجعل الشاشة قابلة للتحرك
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const ProfileTextField(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 20),
              const ProfileTextField(
                labelText: 'Username',
                hintText: 'Enter your username',
              ),
              const SizedBox(height: 20),
              const ProfileTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              const SizedBox(height: 20),
              DropdownField(
                label: 'Gender',
                value: 'Male',
                items: const ['Male', 'Female'],
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              DateField(
                label: 'Your birthday',
                hint: 'DD/MM/YYYY',
                selectedDate: _selectedDate,
                onTap: () => _pickDate(context),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 152, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   EditProfileScreenState createState() => EditProfileScreenState();
// }
//
// class EditProfileScreenState extends State<EditProfileScreen> {
//   DateTime? _selectedDate;
//
//   void _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Center(
//               child: Text(
//                 'Edit Profile',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.brown,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             _buildInputField('Name', ''),
//             const SizedBox(height: 20),
//             _buildInputField('User name', ''),
//             const SizedBox(height: 20),
//             _buildInputField('Email', 'your email id'),
//             const SizedBox(height: 20),
//             _buildInputField('Phone number', '+962 7* *** ****'),
//             const SizedBox(height: 20),
//             _buildDropdownField('Gender', 'Male'),
//             const SizedBox(height: 20),
//             _buildDateField('Your birthday', 'DD/MM/YYYY'),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.brown,
//                   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputField(String label, String hint) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 5),
//         TextField(
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: const Color(0xFFD4C2A8),
//             contentPadding:const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdownField(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           padding:const EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             color:const Color(0xFFD4C2A8),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: DropdownButton<String>(
//             value: value,
//             isExpanded: true,
//             underline:const SizedBox(),
//             items: ['Male', 'Female', 'Other']
//                 .map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e),
//                     ))
//                 .toList(),
//             onChanged: (newValue) {},
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDateField(String label, String hint) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 5),
//         GestureDetector(
//           onTap: () => _pickDate(context),
//           child: Container(
//             padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//             decoration: BoxDecoration(
//               color:const Color(0xFFD4C2A8),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _selectedDate == null
//                       ? hint
//                       : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
//                   style:const TextStyle(color: Colors.black54, fontSize: 16),
//                 ),
//                 const Icon(Icons.calendar_today, color: Colors.grey),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
