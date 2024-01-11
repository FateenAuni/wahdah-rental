import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPart extends StatefulWidget {
  const SearchPart(List car, {super.key});

  @override
  State<SearchPart> createState() => _SearchPartState();
}

class _SearchPartState extends State<SearchPart> {
  var inputText = "";
  double minPrice = 0.0;
  double maxPrice = double.infinity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          inputText = val.toLowerCase();
                          print(inputText);
                        });
                      },
                      decoration: InputDecoration(labelText: 'Search'),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Car").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading..."),
                      );
                    }
                    List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return data['Manufacturer'].toString().toLowerCase().contains(inputText) ||
                             data['vehicle_name'].toString().toLowerCase().contains(inputText);
                    }).toList();

                    return ListView(
                      children: filteredDocs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(data['Manufacturer']),
                            subtitle: Text('${data['vehicle_name']}'),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
