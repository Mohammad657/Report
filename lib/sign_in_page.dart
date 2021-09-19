import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class SignInPage extends StatelessWidget {
  LocationPermission permission;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'تسجيل دخول',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: (Column(
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/a.png'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  child: Text(
                'نضام الابلاغ عن الجرائم بشكل الكتروني',
                style: TextStyle(fontSize: 22),
              )),
              Text(
                'ملاحضة / في حالة عدم الموافقة على الصلاحيات لن يتمكن التطبيق من العمل',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    await Permission.location.request().isGranted;
                    var status = await Permission.phone.status;
                    if (await Permission.location.isDenied) {
                      await Permission.location.request().isGranted;
                    } else if (status.isDenied) {
                      await Permission.phone.request().isGranted;
                    }
                  },
                  child: Text(
                    'الموافقة على الشروط والصلاحيات',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
                var status = await Permission.phone.status;
                if (await Permission.location.isGranted &&
                    status.isGranted) {
              final GoogleSignInAccount googleUser =
              await GoogleSignIn().signIn();
              final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
              final GoogleAuthCredential credential =
              GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken);
              await FirebaseAuth.instance
                  .signInWithCredential(credential)
                  .then((value) => print('registered'));
              }
              }

                  ,child: Text(
                    'سجل دخول بحساب كوكل',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
             child: Text(
               'تسجيل الدخول بمثابة موافقة على الشروط والقوانين الخاصه بالبرنامج', style: TextStyle(fontSize: 10),
             ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
