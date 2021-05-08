import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {

  final String username;

  const ProfilePage({Key key, this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile Page"),
      ),
    );
  }
}
