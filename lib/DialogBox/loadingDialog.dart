import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10,),
          Text("Authenticating, Please wait...."),
        ],
      ),
    );
  }
}