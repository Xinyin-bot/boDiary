import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_ninja/comment.dart';

import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import 'Post.dart';
import 'user.dart';

Color mainColor = Color(0xff6B2480);
Color secondColor = Color(0xffD8399B);
Color thirdColor = Color(0xffF78484);
Color forthColor = Color(0xffFDBE89);

class UserDetailsScreen extends StatefulWidget {
  final Post postsss;
  final User usersss;

  // UserDetailsScreen(this.postsss, this.usersss);
  const UserDetailsScreen({Key key, this.postsss, this.usersss})
      : super(key: key);

//    @override
//    _UserDetailsScreenState createState() => _UserDetailsScreenState(postsss, usersss);
//  }

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  // Post posts;
  // User users;
  // _UserDetailsScreenState(Post postsss, User usersss);
  double screenHeight;
  double screenWidth;

  final TextEditingController _postcaptioncontroller = TextEditingController();

  String _postcaption = "";

  File _image;
  String pathAsset = "assets/images/camera.png";

  @override
  void initState() {
    super.initState();
    // posts = widget.postsss;
    // users = widget.usersss;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(widget.usersss.username),
        ),
        body: 
        // ListView(
        //   children:<Widget>[
        //     CustomSocialWidget(),
        //     SocialInfo(),
        //   ],
        // ),
        Column(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: (Column(
                children: [
                  Container(
                      //padding: EdgeInsets.all(20),
                      child: Column(
                    children: [
                      Container(
                          child: Column(children: [
                        SizedBox(height: 15),
                        Row(children: [
                          SizedBox(width: 5),
                          Container(
                              width: 125.0,
                              height: 125.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "http://sopmathpowy2.com/BoDiary/images/userimages/${widget.usersss.userimage}.jpg"),
                                    // image:AssetImage('assets/images/ic_logo_transparent.png')
                                    fit: BoxFit.fill,
                                  ))),
                          SizedBox(width: 15),
                          Text(widget.usersss.username,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: 15),
                      ])),
                    ],
                  )),
                  SocialInfo(),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () => _addPostDetails(),
                  )
                ],
              ))),
        ])
        );
  }

  _addPostDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {_onPictureSelection()},
                    child: Container(
                      height: screenHeight / 4,
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
                  TextField(
                      controller: _postcaptioncontroller,
                      decoration: InputDecoration(
                          labelText: "Comment",
                          suffixIcon: IconButton(
                            onPressed: () {
                              _updatenewpost();
                            },
                            icon: Icon(Icons.send),
                          ))),
                ],
              ),
            ));
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
                        onPressed: () => {
                          Navigator.pop(context),
                          setState(() {
                            _chooseCamera();
                          })
                        },
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
                          setState(() {
                            _chooseGallery();
                          })
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
      setState(() {
        print("seState of _image...");
        _image = croppedFile;
      });
    }
  }

  void _updatenewpost() {
    final dateTime = DateTime.now();
    _postcaption = _postcaptioncontroller.text;

    String base64Image = base64Encode(_image.readAsBytesSync());
    print(base64Image);

    http.post("http://sopmathpowy2.com/BoDiary/php/add_newPost.php", body: {
      "username": widget.usersss.username,
      "postimagename": widget.usersss.username + "-${dateTime.microsecondsSinceEpoch}",
      "postcaption": _postcaption,
      "encoded_string": base64Image,
      "datepost": "-${dateTime.microsecondsSinceEpoch}",
      // "datepost": dateTime.microsecondsSinceEpoch, //with error int is
    }).then((res) {
      print(res.body);

      if (res.body == "POST UPLOAD FAILED!") {
        Toast.show(
          "Failed!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Success!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      }
    }).catchError((err) {
      print(err);
    });
  }
}

class SocialInfo extends StatelessWidget {
  const SocialInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children:<Widget>[
      Container(height:100, color:Colors.white),
      Container(padding:EdgeInsets.only(top:25),
      height:100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(75),
          bottomRight: Radius.circular(75),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[
          Column(children:<Widget>[
              Text('Photos', style: TextStyle(color:thirdColor,fontSize:16),),
              Text('57', style:TextStyle(color:mainColor, fontSize:25, fontWeight:FontWeight.w700),),
            ],),
          Column(children:<Widget>[
              Text('Followers', style: TextStyle(color:thirdColor,fontSize:16),),
              Text('231', style:TextStyle(color:mainColor, fontSize:25, fontWeight:FontWeight.w700),),
            ],),
          Column(children:<Widget>[
              Text('Follows', style: TextStyle(color:thirdColor,fontSize:16),),
              Text('176', style:TextStyle(color:mainColor, fontSize:25, fontWeight:FontWeight.w700),),
            ],),
        ]
      )
      ),
    ]
    );
  }
}

class CustomSocialWidget extends StatelessWidget {
  const CustomSocialWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding:EdgeInsets.all(25),
decoration:BoxDecoration(
color:Colors.white,
borderRadius:BorderRadius.only(bottomRight: Radius.circular(75))),
child:Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:<Widget>[
        Icon(Icons.arrow_back,color: mainColor),
        Icon(Icons.more_vert, color: mainColor),
      ]),
      SizedBox(
        width:double.infinity,
        child:Text(
          'Ma Profile',
          style: TextStyle(fontSize: 30, color: mainColor),
        ),
      ),
      Container(
        width:120,
        height:120,
        decoration:BoxDecoration(
          shape:BoxShape.circle,
          image:DecorationImage(image:AssetImage('assets/images/ic_logo_transparent.png'),
          ),
          boxShadow:[
    BoxShadow(
      color: secondColor,
      blurRadius: 40,
      offset: Offset(0,10),
    ),
          ],
        ),
      ),
      Container(),
      Text('Anastasia Mari',style:TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color:mainColor,)),
      Text('@xinyin',style:TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: secondColor,)),
      
  ],
)
    );
  }
}
