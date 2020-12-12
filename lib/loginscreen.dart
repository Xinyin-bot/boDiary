import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registerscreen.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Loginscreen());

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();

  String _email = "";
  String _pass = "";

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
        body: Center(
          child: SingleChildScrollView(
              //enable to scroll and prevent overflow when keyboard pop out
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/LogoTransparent.png",
                        scale: 1,
                      ),
                      TextField(
                          controller: _emcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email", icon: Icon(Icons.email,color: Color(0xff6B2480)))),
                      TextField(
                        controller: _pscontroller,
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
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Login'),
                        color: Colors.black,
                        disabledColor: Colors.red,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _onPress,
                      ),
                      SizedBox(height: 20),
                        GestureDetector(
                          onTap: _onRegister,
                          child: Text("Register New Account",
                              style: TextStyle(fontSize: 15,
                              color: Color(0xff6B2480),
                              decoration:TextDecoration.underline))),
                      SizedBox(height: 15),
                      GestureDetector(
                          onTap: _onForget,
                          child: Text("Forgot Password",
                              style: TextStyle(fontSize: 15))),
                    ],
                  ))),
        ),
      ),
    );
  }

  void _onChange(bool value) {//implement through Checkbox
    setState(() {
      _rememberMe = value;//change to new value: true or false
      savepref(value);//pass to savepref method
    });
  }

  void _onPress() {
    print("Press");

    if(_email.isEmpty || _pass.isEmpty)
    {
      Toast.show(
        "Email/Password is empty",
         context,
         duration: Toast.LENGTH_LONG,
         gravity: Toast.CENTER,
         );
    }

  }

  void _onRegister() {
    print("register new account");

    Navigator.push
         (
           context, 
           MaterialPageRoute(
             builder: (BuildContext context) => Registerscreen())
         );
  }

  void _onForget() {
    print("forgot password");
  }

  void loadpref() async{ //to wait from promise of database 
                              // await need to use with async
    prefs = await SharedPreferences.getInstance();

    _email = (prefs.getString('email')) ?? '';
    _pass = (prefs.getString('password')) ?? '';
    
    _rememberMe = (prefs.getBool('rememberMe')) ?? false;

    if(_email.isNotEmpty)
    {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _pass;
        _rememberMe = _rememberMe;
      });

    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();

    _email = _emcontroller.text;// to get email value to store
    _pass = _pscontroller.text;// to get password value to store

    
    if(value){// if value is true
      if(_email.length<5 && _pass.length<3)
      {
        print("EMAIL/PASSWORD IS EMPTY/NOT VALID");
        _rememberMe = false;// not allowed user to save cuz it is empty
        
        Toast.show(
          "Email/Password is empty",
           context,
           duration: Toast.LENGTH_LONG,
           gravity: Toast.CENTER,
           );
        
        return;
      }
      else
      {
        await prefs.setString('email', _email);//to store email value
        await prefs.setString('password', _pass);//to store password value
        await prefs.setBool('rememberMe', value);//store into Preferences if value is true
        
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );

        print("SAVED PREFERENCES SUCCEED");
      }
    }else{//if value if false, don't save value
        await prefs.setString('email', '');//remove preferences
        await prefs.setString('password', '');//remove preferences
        await prefs.setBool('rememberMe', false);
        
        setState(() {
          _emcontroller.text = '';//set empty textfield
          _pscontroller.text = '';// set empty textfield
          _rememberMe = false;
        });
    }


  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('BackPress');
    return Future.value(false);
  }
}
