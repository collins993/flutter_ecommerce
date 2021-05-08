import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/Admin/admin_signup_page.dart';
import 'package:flutter_ecommerce/Configs/config.dart';
import 'package:flutter_ecommerce/DialogBox/errorDialog.dart';
import 'package:flutter_ecommerce/DialogBox/loadingDialog.dart';
import 'package:flutter_ecommerce/Provider/firebase_auth_services.dart';
import 'package:flutter_ecommerce/Store/store_home.dart';
import 'package:flutter_ecommerce/Widgets/custom_textfields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<FirebaseAuthServices>(context);
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    Future<void> _registerUser(BuildContext context) async {
      try {
        await loginProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } catch (e) {
        print(e.toString());
        return;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: GoogleFonts.lobster().fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    CustomTextField(
                      validator: (val) => val.isNotEmpty
                          ? null
                          : "Please enter an email address",
                      controller: _emailController,
                      hintText: "enter email address",
                      leading: Icons.email,
                      isObsecure: false,
                    ),
                    CustomTextField(
                      validator: (val) => val.length < 6
                          ? "Password must exceed 6 characters"
                          : null,
                      controller: _passwordController,
                      hintText: "enter password",
                      leading: Icons.lock,
                      isObsecure: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await loginProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreHome(),
                            ),
                          );
                        }
                      },
                      height: 50,
                      color: Colors.black,
                      minWidth:
                          loginProvider.isLoading ? null : double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: loginProvider.isLoading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminSignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "I'm Admin",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
