import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData leading;
  final String hintText;
  final Function validator;
  bool isObsecure = true;

  CustomTextField({Key key, this.controller, this.leading, this.hintText, this.isObsecure, this.validator})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        obscureText: widget.isObsecure,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          prefixIcon: Icon(widget.leading, color: Colors.black.withOpacity(0.5),),
          focusColor: Colors.black,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
          )
        ),
      ),
    );
  }
}
