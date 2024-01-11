import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> car;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay selectedTime;

  ReceiptPage(this.car, this.startDate, this.endDate, this.selectedTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manufacturer: ${car['Manufacturer']}'),
            Text('Vehicle Name: ${car['vehicle_name']}'),
            Text('Rental Price: RM ${car['rental_price']}'),
            SizedBox(height: 20),
            Text('Start Date: ${startDate}'),
            Text('End Date: ${endDate}'),
            Text('Time: ${selectedTime.format(context)}'),
            SizedBox(height: 20),
            Text('Total Price: RM ${calculateTotalPrice(startDate, endDate, car['rental_price'], selectedTime)}'),
          ],
        ),
      ),
    );
  }

  
double calculateTotalPrice(DateTime startDate, DateTime endDate, double rentalPrice, TimeOfDay selectedTime) {
 
  int numberOfDays = endDate.difference(startDate).inDays;
  numberOfDays = numberOfDays > 0 ? numberOfDays : 1;
  double totalPrice = numberOfDays * rentalPrice;

  return totalPrice;
}

}