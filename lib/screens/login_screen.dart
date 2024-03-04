//static final ApiClient _apiClient = ApiClient(); // Declare _apiClient as static

import 'package:flutter/material.dart';
import 'package:slide_puzzle/core/api_client.dart';
import 'package:slide_puzzle/utils/validator.dart';
import 'package:slide_puzzle/screens/home.dart';
import 'package:slide_puzzle/screens/game_page.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static final ApiClient _apiClient = ApiClient(); // Declare _apiClient as static

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    TextFormField(
                      validator: (value) => Validator.validateUsername(value ?? ""),
                      controller: usernameController,
                      keyboardType: TextInputType.text, // Changed to TextInputType.text for username
                      decoration: InputDecoration(
                        hintText: "Username", // Changed hint text to Username
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      obscureText: true,
                      validator: (value) => Validator.validatePassword(value ?? ""),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleLogin(context),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 255, 177, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15
                              )
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      // Mocking login request, replace with actual login logic
      // Example: dynamic res = await _apiClient.login(usernameController.text, passwordController.text);
      await Future.delayed(Duration(seconds: 2)); // Simulate login request

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Check login success condition, replace with actual logic
      bool loginSuccess = true;

      if (loginSuccess) {
        // Navigate to GamePage if login success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GamePage(username: usernameController.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }
}


        //MaterialPageRoute(builder: (context) => HomeScreen(accessToken: res['accessToken'])),