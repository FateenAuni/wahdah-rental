import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_wahdah/dashboard.dart';
import 'package:final_wahdah/register.dart';
import 'package:final_wahdah/clipper/clipper1.dart';
import 'package:final_wahdah/clipper/clipper2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildEmail() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
          blurRadius: 6,
          color: Colors.grey.shade400,
        ),
      ]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email cannot be empty";
          }
          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
        controller: emailController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.email_outlined),
          hintText: 'Email',
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
          blurRadius: 6,
          color: Colors.grey.shade400,
        ),
      ]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password cannot be empty";
          }
          return null;
        },
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.lock_outline_rounded),
          hintText: 'Password',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 300),
                painter: RPSCustomPainter(),
              ),
              Positioned(
                top: 16,
                right: -5,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 300),
                  painter: PSCustomPainter(),
                ),
              ),
              Positioned(
                top: 220,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 25),
                _buildEmail(),
                const SizedBox(height: 20),
                _buildPassword(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: _signIn,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [
                        Color(0xff023e8a),
                        Color(0xffcaf0f8),
                      ]),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Register Here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff023e8a),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print("Success");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      } else {
        print("Error: User is null");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
