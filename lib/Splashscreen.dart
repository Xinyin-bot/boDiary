import 'package:flutter/material.dart';
import 'loginscreen.dart'; 

void main() => runApp(Splashscreen());
 
class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoDiary',
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
              Image.asset("assets/images/LogoTransparent.png", height: 200.0, fit: BoxFit.cover),
              SizedBox(height:10),
              ProgressIndicator(),
              ],
            )
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  ProgressIndicator({Key key}) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> 
with SingleTickerProviderStateMixin{
  
  AnimationController controller;//controller
  Animation<double> animation;//animation

  @override
  void initState() {

    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds:2000), vsync:this);
    //animation runs 2 seconds + synchronized with this class

                      //run from 0% to 100%
    animation = Tween(begin:0.0, end: 1.0).animate(controller)..addListener(() 
    {
      setState(() 
      {
        if(animation.value > 0.99)//must put this or not it won't show logo and indicator
        {
          controller.stop();
          //push to loginscreen and cannot return back to last screen
         Navigator.pushReplacement
         (
           context, 
           MaterialPageRoute(
             builder: (BuildContext context) => Loginscreen())//go to login screen
         );
        }

      });
     });
     controller.repeat();
  }

@override
  Widget build(BuildContext context) {
    return CircularProgressIndicator
    //LinearProgressIndicator is a straight-line indicator
       (
         value: animation.value,
         valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
       );
  }
}
