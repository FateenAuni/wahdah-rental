import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.format_overline_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 10),
              Text('User Details:'),
              ListTile(
                title: Text('Email:'),
                subtitle: Text(_user?.email ?? 'N/A'),
              ),
              ListTile(
                title: Text('Display Name:'),
                subtitle: Text(_user?.displayName ?? 'nanti update'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    
                  },
                ),
              ),
              ListTile(
                title: Text('UID:'),
                subtitle: Text(_user?.uid ?? 'N/A'),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
