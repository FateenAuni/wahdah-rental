import 'package:final_wahdah/car_details.dart';
import 'package:final_wahdah/profile.dart';
import 'package:final_wahdah/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _firestoreInstance = FirebaseFirestore.instance;
  final List _car = [];
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  fetchCar() async {
    QuerySnapshot qn = await _firestoreInstance.collection("Car").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _car.add({
          "Manufacturer": qn.docs[i]["Manufacturer"],
          "vehicle_name": qn.docs[i]["vehicle_name"],
          "rental_price": qn.docs[i]["rental_price"],
        });
      }
    });
  }

  void applyFilter(Map<String, dynamic> filters) async {
    QuerySnapshot qn = await _firestoreInstance
        .collection("Car")
        .where('Manufacturer', isEqualTo: filters['manufacturer'])
        .where('rental_price', isGreaterThanOrEqualTo: filters['minPrice'])
        .where('rental_price', isLessThanOrEqualTo: filters['maxPrice'])
        .get();

    setState(() {
      _car.clear();
      for (int i = 0; i < qn.docs.length; i++) {
        _car.add({
          "Manufacturer": qn.docs[i]["Manufacturer"],
          "vehicle_name": qn.docs[i]["vehicle_name"],
          "rental_price": qn.docs[i]["rental_price"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchCar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Wahdah'),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "Search for Cars",
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => SearchPart(_car)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _car.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Details(_car[index]),
                        ),
                      ),
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 2,
                              child: Container(
                                color: Color(0xFF023e8a),
                                child: Image.asset(
                                  'assets/images/car.png',
                                ),
                              ),
                            ),
                            Text("${_car[index]["Manufacturer"]}"),
                            Text("${_car[index]["vehicle_name"]}"),
                            Text("${_car[index]["rental_price"].toString()}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; //update the current index
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00008B),
                    Colors.white,
                  ],
                ),
              ),
              child: Icon(
                Icons.favorite_outline_sharp,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // Right sidebar
      endDrawer: RightSidebar(onApplyFilter: applyFilter),
    );
  }
}

class RightSidebar extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilter;

  const RightSidebar({Key? key, required this.onApplyFilter}) : super(key: key);

  @override
  _RightSidebarState createState() => _RightSidebarState();
}

class _RightSidebarState extends State<RightSidebar> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  List<String> _manufacturers = [];
  final List<String> _selectedManufacturers = [];

  double _minPrice = 0.0;
  double _maxPrice = 1000.0;

  @override
  void initState() {
    super.initState();
    
    fetchManufacturers();
  }

  Future<void> fetchManufacturers() async {
    QuerySnapshot manufacturersSnapshot =
        await FirebaseFirestore.instance.collection('Car').get();

    Set<String> uniqueManufacturers = manufacturersSnapshot.docs
        .map((doc) => doc['Manufacturer'].toString())
        .toSet();

    setState(() {
      _manufacturers = uniqueManufacturers.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF00008B),
            ),
            child: Text('Filter', style: TextStyle(color: Colors.white),),
          ),
          // CheckboxListTile for each manufacturer
          for (String manufacturer in _manufacturers)
            CheckboxListTile(
              title: Text(manufacturer),
              value: _selectedManufacturers.contains(manufacturer),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      _selectedManufacturers.add(manufacturer);
                    } else {
                      _selectedManufacturers.remove(manufacturer);
                    }
                  }
                });
              },
            ),
          ListTile(
            title: Text('Price Range'),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0.0,
            max: 1000.0,
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                Map<String, dynamic> filters = {
                  'manufacturers': _selectedManufacturers,
                  'minPrice': _minPrice,
                  'maxPrice': _maxPrice,
                };

                widget.onApplyFilter(filters);
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

