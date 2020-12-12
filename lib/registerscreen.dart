import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginscreen.dart';

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

  String _name = "";
  String _phone = "";
  String _email = "";
  String _password = "";

  bool _passwordVisible = true;
  bool _termCondition = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //use Scaffold to follow the theme
      appBar: AppBar(
        backgroundColor: Color(0xff6B2480),
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
            //to make validator activate
            key: formKey, //to make validator activate
            autovalidateMode:
                AutovalidateMode.onUserInteraction, //to make validator active
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/LogoTransparent.png",
                    scale: 1,
                  ),
                  TextFormField(
                      controller: _namecontroller,
                      validator: validName,
                      onSaved: (String name) {
                        _name = name;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Name", icon: Icon(Icons.person,color: Color(0xff6B2480)))),
                  TextFormField(
                      controller: _phcontroller,
                      validator: validPhone,
                      onSaved: (String phone) {
                        _phone = phone;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone No", icon: Icon(Icons.phone,color: Color(0xff6B2480)))),
                  TextFormField(
                      controller: _emcontroller,
                      validator: validEmail,
                      onSaved: (String email) {
                        _email = email;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        icon: Icon(Icons.email,color: Color(0xff6B2480)),
                      )),
                  TextFormField(
                    controller: _pscontroller,
                    validator: validPassword,
                    onSaved: (String password) {
                      _password = password;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.lock,color: Color(0xff6B2480)),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xff6B2480),
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
                      icon: Icon(Icons.lock,color: Color(0xff6B2480)),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xff6B2480),
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
                  SizedBox(height: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 300,
                    height: 50,
                    child: Text('Register'),
                    color: Colors.black,
                    textColor: Colors.white,
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
            )),
      ),
    );
  }

  Future<void> _onRegister() async {
    _name = _namecontroller.text;
    _phone = _phcontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);

 
    if ( _name.length == 0 ||
        _phone.length == 0 ||
        _email.length == 0 ||
        _password.length == 0 ||
        _termCondition == false) {
          if(_termCondition == false)
          {
            Toast.show("Please agree Terms & Condition",
             context,
             duration:Toast.LENGTH_LONG,
             gravity:Toast.CENTER,
             );
          }else{
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
          }).then((res) {
        print(res.body);

        if (res.body == "SUCCESS: REGISTER USER") {
          Toast.show(
            "Registration Success! We have sent an verification mail to your email.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
          );
          _onLogin();
        } else if (res.body == "FAILED: REGISTER USER") {
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
}
