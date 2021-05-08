import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/Configs/config.dart';
import 'package:flutter_ecommerce/DialogBox/errorDialog.dart';
import 'package:flutter_ecommerce/DialogBox/loadingDialog.dart';
import 'package:flutter_ecommerce/Profile/profile_page.dart';
import 'package:flutter_ecommerce/Provider/firebase_auth_services.dart';
import 'package:flutter_ecommerce/Store/store_home.dart';
import 'package:flutter_ecommerce/Widgets/custom_textfields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<FirebaseAuthServices>(context);
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    Future<void> _registerUser(BuildContext context) async {
      try {
        await registerProvider.register(
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
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: GoogleFonts.lobster().fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          selectFile();
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    CustomTextField(
                      validator: (val) =>
                          val.isNotEmpty ? null : "Please enter username",
                      controller: _nameController,
                      hintText: "enter username",
                      leading: Icons.person,
                      isObsecure: false,
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
                      validator: (val) =>
                          val.length < 6 ? null : "Please enter more than 6",
                      controller: _passwordController,
                      hintText: "enter password",
                      leading: Icons.lock,
                      isObsecure: true,
                    ),
                    CustomTextField(
                      validator: (val) =>
                          val.length < 6 ? null : "Please enter more than 6",
                      controller: _repeatPasswordController,
                      hintText: "re-enter password",
                      leading: Icons.lock,
                      isObsecure: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await registerProvider.register(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                username:
                                    _nameController.text.toString().trim(),
                              ),
                            ),
                          );
                        }
                      },
                      height: 50,
                      color: Colors.black,
                      minWidth:
                          registerProvider.isLoading ? null : double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: registerProvider.isLoading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Text(
                              "Register",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if(result != null){
      final path = result.files.single.path;
      _imageFile = File(path);
    }
  }

  Future uploadFile() async {
    if(_imageFile == null){
      return;
    }
  }
}
