import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'loginscreen.dart';

Color mainColor = Color(0xff6B2480);
Color secondColor = Color(0xffD8399B);
Color thirdColor = Color(0xffF78484);
Color forthColor = Color(0xffFDBE89);

void main() => runApp(Registerscreen());

class Registerscreen extends StatefulWidget {
  @override
  _RegisterscreenState createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _confirmpscontroller = TextEditingController();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); //to make validator activate

  double screenHeight, screenWidth;

  String _name = "";
  String _phone = "";
  String _email = "";
  String _password = "";

  File _image;
  String pathAsset = "assets/images/camera.png";

  bool _passwordVisible = true;
  bool _termCondition = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //use Scaffold to follow the theme
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Registration'),
      ),
      body: Form(
          //to make validator activate
          key: formKey, //to make validator activate
          autovalidateMode:
              AutovalidateMode.onUserInteraction, //to make validator active
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => {_onPictureSelection()},
                    child: Container(
                      height: screenHeight / 4.2,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(
                                  pathAsset) //'assets/images/camera.png'
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                      controller: _namecontroller,
                      validator: validName,
                      onSaved: (String name) {
                        _name = name;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Name",
                          icon: Icon(Icons.person, color: mainColor))),
                  TextFormField(
                      controller: _phcontroller,
                      validator: validPhone,
                      onSaved: (String phone) {
                        _phone = phone;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone No",
                          icon: Icon(Icons.phone, color: mainColor))),
                  TextFormField(
                      controller: _emcontroller,
                      validator: validEmail,
                      onSaved: (String email) {
                        _email = email;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        icon: Icon(Icons.email, color: mainColor),
                      )),
                  TextFormField(
                    controller: _pscontroller,
                    validator: validPassword,
                    onSaved: (String password) {
                      _password = password;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.lock, color: mainColor),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: mainColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                    obscureText: _passwordVisible,
                  ),
                  TextFormField(
                    controller: _confirmpscontroller,
                    validator: validConfirmPassword,
                    onSaved: (String confirmPassword) {
                      _password = confirmPassword;
                    },
                    decoration: InputDecoration(
                      labelText: "Password Confirmation",
                      icon: Icon(Icons.lock, color: mainColor),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: mainColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                    obscureText: _passwordVisible,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _termCondition,
                        onChanged: (bool value) {
                          _onChange1(value);
                        },
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: _showEULA,
                          child: Text('Agreed Terms & Condition',
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline))),
                    ],
                  ),
                  SizedBox(height: 50),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Register'),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minWidth: double.infinity,
                    textColor: Colors.white,
                    color: mainColor,
                    elevation: 10,
                    onPressed: newRegisterAccount,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: _onLogin,
                      child: Text('Already Registered',
                          style: TextStyle(fontSize: 16))),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _onRegister() async {
    _name = _namecontroller.text;
    _phone = _phcontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;

        final dateTime = DateTime.now();
        String base64Image = base64Encode(_image.readAsBytesSync());
        
        print(base64Image);


    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);

    if (_name.length == 0 ||
        _phone.length == 0 ||
        _email.length == 0 ||
        _password.length == 0 ||
        _termCondition == false) {
      print("_name.length == 0 ....");

      if (_termCondition == false) {
        Toast.show(
          "Please agree Terms & Condition",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      } else {
        Toast.show(
          "Some information is missed!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      }
    } else {
      pr.style(message: "Registration......");
      await pr.show();

      http.post("https://sopmathpowy2.com/BoDiary/php/register_user.php",
          body: {
            "name": _name,
            "phone": _phone,
            "email": _email,
            "password": _password,
            "imagename": _phone + "-${dateTime.microsecondsSinceEpoch}",
            "encoded_string": base64Image,

          }).then((res) {
        print(res.body);

        if (res.body.contains('REGISTRATION SUCCESS!')) {
          Toast.show(
            "Registration Success! We have sent an verification mail to your email.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
          );
          _onLogin();
        } else if (res.body.contains('REGISTRATION FAILED!')) {
          Toast.show(
            "Registration Failed!",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
          );
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    }
  }

  void _onLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Loginscreen()));
  }

  newRegisterAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new account? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onRegister();
              },
            ),
          ],
        );
      },
    );
  }

  String validName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);

    if (value.length == 0) {
      return "Name is empty!";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be in word!";
    }
    return null;
  }

  String validPhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return null;
  }

  String validEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validPassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    }
    return null;
  }

  String validConfirmPassword(String value) {
    String password = _pscontroller.text;
    if (value.length == 0) {
      return "Password is Required";
    } else if (!(value == password)) {
      return "Password is not same";
    }
    return null;
  }

  void _onChange1(bool value) {
    setState(() {
      _termCondition = value;
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("End-User License Agreement (EULA) of BoDiary",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          content: Container(
            height: 500,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          ),
                          text:
                              "This End-User License Agreement is a legal agreement between you and sopmathpowy2. This EULA agreement governs your acquisition and use of our Gardeneous software (Software) directly from Sopmy520 or indirectly through a Sopmy520 authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Gardeneous software. It provides a license to use the Gardeneous e software and contains warranty information and liability disclaimers. If you register for a free trial of the BoDiary software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using this software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by sopmathpowy2 herewith regardless of whether other software is referred to or described herein. The terms also apply to any sopmathpowy2 updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Gardeneous. sopmathpowy2 shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of sopmathpowy2. sopmathpowy2 reserves the right to grant licences to use the Software to third parties",
                        )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Colors.grey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Colors.grey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  _chooseCamera() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  _chooseGallery() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Croppper',
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
