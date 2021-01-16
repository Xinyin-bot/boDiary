import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ninja/mainscreen.dart';
import 'package:food_ninja/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'registerscreen.dart';

void main() => runApp(Loginscreen());

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();

  String _email = "";
  String _password = "";

  bool _rememberMe = false;
  bool _passwordVisible = true;

  SharedPreferences prefs;

  void initState() //load this method: check something before layout loading
  {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff6B2480),
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
              //enable to scroll and prevent overflow when keyboard pop out
              child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/ic_logo_transparent.png",
                        width: 180,
                        //width: 150,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: _emcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email",
                              icon:
                                  Icon(Icons.email, color: Color(0xff6B2480)))),
                      TextField(
                        controller: _pscontroller,
                        decoration: InputDecoration(
                          labelText: "Password",
                          icon: Icon(Icons.lock, color: Color(0xff6B2480)),
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
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              onChanged: (bool value) {
                                _onChange(value);
                              }),
                          Text("Remember Me", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),

                        // minWidth: 300,
                        // height: 50,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minWidth: double.infinity,
                        child: Text('Login'),
                        color: Color(0xff6B2480),
                        disabledColor: Colors.grey,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _onLogin,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: _onForget,
                          child: Text("Forgot Password?",
                              style: TextStyle(fontSize: 15))),
                      SizedBox(height: 80),
                      GestureDetector(
                          onTap: _onRegister,
                          child: Text("No Account Yet? Register New Account",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff6B2480),
                                  decoration: TextDecoration.underline))),
                    ],
                  ))),
        ),
      ),
    );
  }

  void _onChange(bool value) {
    //implement through Checkbox
    setState(() {
      _rememberMe = value; //change to new value: true or false
      savepref(value); //pass to savepref method
    });
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login......");
    await pr.show();

    if (_email.isEmpty || _password.isEmpty) {
      Toast.show(
        "Email/Password is empty",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
    } else {
      http.post("https://sopmathpowy2.com/BoDiary/php/login_user.php", body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.body);

        List userdata = res.body.split(",");

        if (userdata[0] == "success") {
          Toast.show("Login Success!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

          User userrr = new User(
            username: userdata[1],
            userphone: userdata[2],
            userimage : userdata[3],
            useremail : _email,
          );
            
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Mainscreen(user: userrr)));


          //_onMainScreen();
        } else if (res.body.contains("LOGIN FAILED!")) {
          Toast.show("Login Failed!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      }).catchError((err) {
        print(err);
      });
    }
    await pr.hide();
  }

  void _onRegister() {
    print("register new account");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Registerscreen()),
    );
  }

  void _onForget() {
    print("forgot password");
  }

  void loadpref() async {
    //to wait from promise of database
    // await need to use with async
    prefs = await SharedPreferences.getInstance();

    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';

    _rememberMe = (prefs.getBool('rememberMe')) ?? false;

    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();

    _email = _emcontroller.text; // to get email value to store
    _password = _pscontroller.text; // to get password value to store

    if (value) {
      // if value is true
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD IS EMPTY/NOT VALID");
        _rememberMe = false; // not allowed user to save cuz it is empty

        Toast.show(
          "Email/Password is empty",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );

        return;
      } else {
        await prefs.setString('email', _email); //to store email value
        await prefs.setString('password', _password); //to store password value
        await prefs.setBool(
            'rememberMe', value); //store into Preferences if value is true

        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );

        print("SAVED PREFERENCES SUCCEED");
      }
    } else {
      //if value if false, don't save value
      await prefs.setString('email', ''); //remove preferences
      await prefs.setString('password', ''); //remove preferences
      await prefs.setBool('rememberMe', false);

      setState(() {
        _emcontroller.text = ''; //set empty textfield
        _pscontroller.text = ''; // set empty textfield
        _rememberMe = false;
      });
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('BackPress');
    return Future.value(false);
  }

  void _onMainScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Mainscreen()));
  }
}
