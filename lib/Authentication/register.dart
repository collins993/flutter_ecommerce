import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/Configs/config.dart';
import 'package:flutter_ecommerce/DialogBox/errorDialog.dart';
import 'package:flutter_ecommerce/DialogBox/loadingDialog.dart';
import 'package:flutter_ecommerce/Store/store_home.dart';
import 'package:flutter_ecommerce/Widgets/custom_textfields.dart';
import 'package:image_picker/image_picker.dart';

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
  final GlobalKey _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  dynamic _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
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
            InkWell(
              onTap: () => _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth / 5,
                backgroundColor: Colors.grey[400],
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: _screenWidth / 5,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    hintText: "enter username",
                    leading: Icons.person,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "enter email address",
                    leading: Icons.email,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "enter password",
                    leading: Icons.lock,
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _repeatPasswordController,
                    hintText: "re-enter password",
                    leading: Icons.lock,
                    isObsecure: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        uploadAndSaveImage();
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 2.0,
                    width: _screenWidth / 1.3,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "Please select an image file.");
          });
    } else {
      _passwordController.text == _repeatPasswordController.text
          ? _emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _repeatPasswordController.text.isNotEmpty &&
                  _nameController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill out all field correctly")
          : displayDialog("Password do not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog();
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask storageUploadTask = reference.putFile(_imageFile);
    TaskSnapshot taskSnapshot =
        await storageUploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User userCredential;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      userCredential = auth.user;
    }).catchError((e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: e.toString(),
            );
          });
    });

    if(userCredential != null){
      saveUserInfoToFireStore(userCredential).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> StoreHome()));
      });
    }
  }

  Future saveUserInfoToFireStore(User userCredential) async {
    FirebaseFirestore.instance.collection('User').doc(userCredential.uid).set({
      'uid' : userCredential.uid,
      'email' : userCredential.email,
      'name' : _nameController.text.trim(),
      'url' : userImageUrl,
    });

    await EcommerceApp.sharedPreferences.setString('uid', userCredential.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, userCredential.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }

}
