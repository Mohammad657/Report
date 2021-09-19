import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_phone_number/get_phone_number.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position _currentPosition;
  String _currentAddress;
  final module = GetPhoneNumber();
  TextEditingController name1 = TextEditingController();
  TextEditingController datatime = TextEditingController();
  final TextEditingController LocationController = TextEditingController();
  final TextEditingController DescribController = TextEditingController();
  final TextEditingController PersionalController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  TextEditingController dateTime = TextEditingController();
  TextEditingController location = TextEditingController();
  bool serviceEnabled;
  LocationPermission permission;
  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  getPhoneNumber() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    List<String> PhoneController = await GetPhoneNumber().getListPhoneNumber();
    _getCurrentLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    });
    Map<String, dynamic> data = {
      'Datetime':  formattedDate +' '+ formattedTime ,
      'Latitude:': _currentPosition.latitude,
      'longitude:': _currentPosition.longitude,
      'Telephone_number:': PhoneController,
      'Personal_amount_information:': PersionalController.text,
      'place_crime:': LocationController.text,
      'Description_crime:': name1.text,
      'time_in_crime':datatime.text,
    };
    FirebaseFirestore.instance.collection('Crime_information').add(data);
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ادراج التبليغ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  'تتحمل المسؤولية القانونية الكاملة في حالة تزيف المعلومات وتشويش عمل الشرطة ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: PersionalController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'اسم المبلغ ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.text_snippet_sharp)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: LocationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'مكان الجريمة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_pin)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: name1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'وصف الجريمة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: datatime,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'وقت الجريمة الفعلي',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description)),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () async {
                    getPhoneNumber();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                      content: Text(
                        " تم الارسال بنجاح",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ));
                  },
                  child: Text(
                    "رفع معلومات الجريمة",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    User user = FirebaseAuth.instance.currentUser;
                  },
                  child: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
