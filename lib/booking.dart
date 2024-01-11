import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_wahdah/receipt.dart';

class BookingPage extends StatefulWidget {
  var _car;

  BookingPage(this._car);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;

  Future<void> bookNow() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference userBookCollection =
        FirebaseFirestore.instance.collection("users-book");

    await userBookCollection.doc(currentUser!.email).set({
      "Manufacturer": widget._car['Manufacturer'],
      "vehicle_name": widget._car['vehicle_name'],
      "rental_price": widget._car['rental_price'],
      "start_date": startDate,
      "end_date": endDate,
      "selected_time": selectedTime?.format(context),
    });

    print("Booking details added to Firestore");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Booking '),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.pause_circle_outline_outlined),
          )
        ],
      ),
      body: Padding(
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
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date:'),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );

                          if (pickedDate != null && pickedDate != startDate) {
                            setState(() {
                              startDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          startDate != null
                              ? startDate!.toLocal().toString().split(' ')[0]
                              : 'Select Start Date',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Date:'),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );

                          if (pickedDate != null && pickedDate != endDate) {
                            setState(() {
                              endDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          endDate != null
                              ? endDate!.toLocal().toString().split(' ')[0]
                              : 'Select End Date',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Time:'),
            ElevatedButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null && pickedTime != selectedTime) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: Text(
                selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Select Time',
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              if (startDate != null && endDate != null && selectedTime != null) {
                await bookNow();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReceiptPage(widget._car, startDate!, endDate!, selectedTime!),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Incomplete Details"),
                      content: Text("Please select start date, end date, and time."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              "BOOK NOW",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF023e8a),
              elevation: 3,
            ),
          ),
        ),
      ),
    );
  }
}
