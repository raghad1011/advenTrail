import 'package:flutter/material.dart';
import '../component/custom_text_field.dart';


class NewpasswordScreen extends StatefulWidget {
  const NewpasswordScreen({super.key});

  @override
  _NewpasswordScreen createState() => _NewpasswordScreen();
}

class _NewpasswordScreen extends State<NewpasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Colors.transparent,
   elevation: 0,  
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Color(0xff4f331e),size:32,),
          onPressed: () {
            Navigator.pop((context),'/verify'); // العودة إلى الصفحة السابقة
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Positioned(
                top: 80,
                left: 150,
                child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
              ),
              const SizedBox(height: 20),

              const Text(
                "New Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff361C0B),
                ),
              ),
              const SizedBox(height: 20,),
              
               const CustomTextField(
                icon: Icons.lock,
                hintText: 'New Password',
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              const SizedBox(height: 10,),
               const CustomTextField(
                icon: Icons.lock,
                hintText: 'Confirm Password',
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              const SizedBox(height: 80,),

              SizedBox(
                width: 390,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5,),
              ],
          ),),),);
  }} 