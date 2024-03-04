import 'package:flutter/material.dart';
import 'package:slide_puzzle/core/api_client.dart';
import 'package:slide_puzzle/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;

  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient(); // Initialize your ApiClient

  Future<Map<String, dynamic>> getUserData() async {
    dynamic userRes;
    userRes = await _apiClient.getUserProfileData(widget.accessToken);
    return userRes;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: size.height,
                width: size.width,
                color: Colors.blueGrey,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData) {
              String fullName = snapshot.data!['FullName'];
              String firstName = snapshot.data!['FirstName'];
              String lastName = snapshot.data!['LastName'];
              String birthDate = snapshot.data!['BirthDate'];
              String email = snapshot.data!['Email'][0]['Value'];
              String gender = snapshot.data!['Gender'];

              return Container(
                width: size.width,
                height: size.height,
                color: Colors.blueGrey.shade400,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text('Full Name: $fullName'),
                      Text('First Name: $firstName'),
                      Text('Last Name: $lastName'),
                      Text('Birth Date: $birthDate'),
                      Text('Email: $email'),
                      Text('Gender: $gender'),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          await _apiClient.logout(widget.accessToken);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox(); // Handle if there's no data
          },
        ),
      ),
    );
  }
}
