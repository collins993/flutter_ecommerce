import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/Authentication/authentication.dart';
import 'package:flutter_ecommerce/Provider/firebase_auth_services.dart';
import 'package:provider/provider.dart';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    final logoutProvider = Provider.of<FirebaseAuthServices>(context);
    return Scaffold(
      body: Center(
          child: MaterialButton(
        onPressed: () async {
          await logoutProvider.logOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Authentication(),
            ),
          );
        },
        color: Colors.amber,
        child: Text("LogOut"),
      )),
    );
  }
}
