import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
              Image.asset("assets/images/ic_logo_transparent.png", height: 200.0, fit: BoxFit.cover),
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

    controller = AnimationController(duration: const Duration(milliseconds:2000), vsync: this);
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
    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      width: 140.0,
      lineHeight: 5.0,
      percent: 1.0,
      animation: true,
      animationDuration: 2500,
      backgroundColor: Colors.grey,
      progressColor: Color(0xff6B2480),
      onAnimationEnd: (){

      },
    );
  }
}
