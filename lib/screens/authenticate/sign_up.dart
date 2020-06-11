import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/Shared/loading.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/Shared/constans.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Variables
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text field state
  String email = '';
  String password = '';
  String name = '';
  String lastname = '';
  String phone = '';
  String error = '';
  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Register for To Do's app"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Sign In"))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Title(
                      color: Colors.black,
                      child: Text(
                        'Register new User',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          TextInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter a email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          TextInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter a password of 6 chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          TextInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) => val.isEmpty ? 'Enter a Name' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          TextInputDecoration.copyWith(hintText: 'Last Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter a Last name' : null,
                      onChanged: (val) {
                        setState(() => lastname = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: TextInputDecoration.copyWith(
                          hintText: 'Phone number'),
                      validator: (val) => !val.contains(new RegExp(r'^[0-9]*$'))
                          ? 'Enter a Phone number valid'
                          : null,
                      onChanged: (val) {
                        setState(() => phone = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: sampleImage == null
                          ? Text(
                              'Cargar Imagen',
                              style: TextStyle(color: Colors.white),
                            )
                          : enableUpload(),
                      onPressed: getImage,
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.signUpWithEmailPassword(
                              email, password, name, lastname, phone);
                          if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              loading = false;
                            });
                          } else {
                            uploadImage(result, sampleImage);
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 200.0, width: 200.0),
        ],
      ),
    );
  }
}

Future<String> uploadImage(res, samImg) async {
  final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(res.uid + '.jpg');
  final StorageUploadTask task = firebaseStorageRef.putFile(samImg);

  var downUrl = await (await task.onComplete).ref.getDownloadURL();
  var url = downUrl.toString();
  await DatabaseService(uid: res.uid).updateUserData(url);

  print(url);

  return url;
}
