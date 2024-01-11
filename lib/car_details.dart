import 'package:final_wahdah/booking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  var _car;

  Details(this._car);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future bookNow() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =FirebaseFirestore.instance.collection("users-book");
    return _collectionRef.doc(currentUser!.email).collection("car").doc().set({
      "Model": widget._car['Manufacturer'],
      "Type": widget._car['vehicle_name'],
      "Price": widget._car['rental_price'],
    }).then((value) => print("Book"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Details'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_outlined))
        ],
      ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                Center(
              child: Text(widget._car['Manufacturer']),
            ),
            Center(
              child: Text(widget._car['vehicle_name']),
            ),
            Center(
              child: Text('RM ${widget._car['rental_price'].toString()}'),
            ),
            SizedBox(height:20,),
                SizedBox(
                    width: 1200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingPage(widget._car),
                          ),
                        );
                      },
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF023e8a),
                        elevation: 3,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
