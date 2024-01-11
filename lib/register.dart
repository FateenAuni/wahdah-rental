import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_wahdah/clipper/clipper1.dart';
import 'package:final_wahdah/clipper/clipper2.dart';
import 'package:final_wahdah/dashboard.dart';
import 'package:final_wahdah/firebase_auth_implement/service_auth.dart';
import 'package:final_wahdah/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPass = TextEditingController();
  var unameController = TextEditingController();

  @override
  void dispose() {
    unameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPass.dispose();
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
            return "Email";
          }
        },
        controller: emailController,
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Email'),
      ),
    );
  }

  Widget _buildPass() {
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
            return "Password";
          }
        },
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock_outline_rounded),
            hintText: 'Password'),
      ),
    );
  }

  Widget _buildConPass() {
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
            return "Confirm Password";
          }
        },
        controller: confirmPass,
        obscureText: true,
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock_outline_rounded),
            hintText: 'Confirm Password'),
      ),
    );
  }

  Widget _buildUsername() {
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
            return "Username";
          }
        },
        controller: unameController,
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.person),
            hintText: 'Username'),
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
                      'Register Here',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign up to continue',
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
                _buildUsername(),
                const SizedBox(height: 20),
                _buildEmail(),
                const SizedBox(height: 20),
                _buildPass(),
                const SizedBox(
                  height: 20,
                ),
                _buildConPass(),
                SizedBox(
                  height: 20,
                ),
                //buttonnya
                InkWell(
                  onTap: _signUp,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff023e8a),
                          Color(0xffcaf0f8),
                        ],
                      ),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Sign Up",
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
                        )
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
                      "Already Have an Account? ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff023e8a)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = unameController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        print("Success");

        //sotror data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
        });

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
