import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_ninja/Post.dart';
import 'package:food_ninja/postdetailsscreen.dart';
import 'package:food_ninja/user.dart';
import 'package:food_ninja/userdetailsscreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


Color mainColor = Color(0xff6B2480);
Color secondColor = Color(0xffD8399B);
Color thirdColor = Color(0xffF78484);
Color forthColor = Color(0xffFDBE89);

void main() => runApp(Mainscreen());

class Mainscreen extends StatefulWidget {
  final User user;
  final Post post;

  const Mainscreen({Key key, this.user, this.post}) : super(key: key);

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List postList;
  List userList;

  initState() {
    super.initState();
    _loadPost();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('Bodiary'),
          actions:<Widget>[
            IconButton(
              icon: Icon(
                Icons.person, 
                color:Colors.white,),
                onPressed: () => _userDetailsScreen(),
            )
          ],
        ),
        
        body: Column(
          children: [
            postList == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text("No Post Found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )))))
                : Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: postList.length,
                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          print(postList.length);
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              semanticContainer: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 10,
                              child: InkWell(
                                  onTap: () => _loadPostUserDetails(index),
                                  child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: (Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(children: [
                                                    Container(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  //image: userList[index]['userimage'] != null ?
                                                                  // NetworkImage(
                                                                  //     "http://sopmathpowy2.com/BoDiary/images/userimages/${userList[0]['userimage']}.jpg") :
                                                                      
                                                                    image:  AssetImage('assets/images/ic_logo_transparent.png'),
                                                                  fit: BoxFit.fill,
                                                                ))),
                                                    SizedBox(width: 15),
                                                    InkWell(
                                                      child:Text(
                                                        postList[index]
                                                            ['username'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                                    ),
                                                                    onTap: () => _loadPostUserDetails(index))
                                                    
                                                  ]),
                                                  SizedBox(height: 15),
                                                  Container(
                                                      // height: screenHeight / 3.8,
                                                      // width: screenWidth / 1.2,
                                                      child: CachedNetworkImage(
                                                    imageUrl:
                                                        "http://sopmathpowy2.com/BoDiary/images/postimages/${postList[index]['postimage']}.jpg",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            new Icon(
                                                      Icons.broken_image,
                                                      size: screenWidth / 2,
                                                    ),
                                                  )),
                                                  SizedBox(height: 5),
                                                  Row(children: [
                                                    Text(
                                                        postList[index]
                                                            ['postcaption'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ]),

                                                  //Text(DateFormat('yyyy-MM-dd hh:mm aaa').format(postList[index]['postdate'])),
                                                  Row(children: [
                                                    Text(postList[index]
                                                        ['postdate']),
                                                  ]),
                                                ],
                                              )),
                                        ],
                                      )))),
                            ),
                          );
                        })

                    // child: GridView.count(
                    //   crossAxisCount: 1,
                    //   childAspectRatio: (screenWidth / screenHeight) / 0.5,
                    //   children: List.generate(
                    //     postList.length,
                    //     (index) {
                    //       return Padding(
                    //         padding: EdgeInsets.all(10),
                    //         child: Card(
                    //           semanticContainer: true,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(30.0),
                    //           ),
                    //           elevation: 10,
                    //           child: InkWell(
                    //               onTap: () => _loadPostUserDetails(index),
                    //               child: Padding(
                    //                   padding: EdgeInsets.all(3),
                    //                   child: (Column(
                    //                     children: [
                    //                       Container(
                    //                           padding: EdgeInsets.all(20),
                    //                           child: Column(
                    //                             children: [
                    //                               Row(children: [
                    //                                 Icon(Icons.person),
                    //                                 SizedBox(width: 5),
                    //                                 Text(
                    //                                     postList[index]
                    //                                         ['username'],
                    //                                     style: TextStyle(
                    //                                         fontSize: 15,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold)),
                    //                               ]),
                    //                               SizedBox(height: 15),
                    //                               Container(
                    //                                   // height: screenHeight / 3.8,
                    //                                   // width: screenWidth / 1.2,
                    //                                   child: CachedNetworkImage(
                    //                                 imageUrl:
                    //                                     "http://sopmathpowy2.com/BoDiary/images/postimages/${postList[index]['postimage']}.jpg",
                    //                                 fit: BoxFit.cover,
                    //                                 placeholder: (context,
                    //                                         url) =>
                    //                                     new CircularProgressIndicator(),
                    //                                 errorWidget:
                    //                                     (context, url, error) =>
                    //                                         new Icon(
                    //                                   Icons.broken_image,
                    //                                   size: screenWidth / 2,
                    //                                 ),
                    //                               )),
                    //                               SizedBox(height: 5),
                    //                               Row(children: [
                    //                                 Text(
                    //                                     postList[index]
                    //                                         ['postcaption'],
                    //                                     style: TextStyle(
                    //                                         fontSize: 15,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold)),
                    //                               ]),

                    //                               //Text(DateFormat('yyyy-MM-dd hh:mm aaa').format(postList[index]['postdate'])),
                    //                               Row(children: [
                    //                                 Text(postList[index]
                    //                                     ['postdate']),
                    //                               ]),
                    //                             ],
                    //                           )),
                    //                     ],
                    //                   )))),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    ),
          ],
        ));
  }

  void _loadPost() {
    print("Load Post");

    http.post("http://sopmathpowy2.com/BoDiary/php/load_post.php",
        body: {}).then((res) {
      print("!!!" + res.body);

      if (res.body == "nodata") {
        postList = null;
        print("postList Null");
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          postList = jsondata["posts"];

          print("postList get");
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadUser() {
    print("Load User");

    http.post("http://sopmathpowy2.com/BoDiary/php/load_user.php",
        body: {}).then((res) {
      print("..." + res.body);

      if (res.body == "nodata") {
        userList = null;
        print("userList Null");
      } else {
        print("have data");
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          userList = jsondata["users"];

          print("userList get");
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadPostUserDetails(int index) {
    Post posts = new Post(
      postid: postList[index]['postid'],
      username: postList[index]['username'],
      postimage: postList[index]['postimage'],
      postcaption: postList[index]['postcaption'],
      postdate: postList[index]['postdate'],
    );

    // User users = new User(
    //   username: userList[index]['username'],
    //   userphone: userList[index]['userphone'],
    //   userimage: userList[index]['userimage'],
    //   useremail: userList[index]['useremail'],
    // );
    // print(index);
    // print(postList.length);
    // print(posts.username);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PostDetailsScreen(posts, widget.user),
    ));
  }

    void _userDetailsScreen() {

        Navigator.push(context, MaterialPageRoute(
      builder:(BuildContext context) => 
      UserDetailsScreen(postsss: widget.post,usersss: widget.user)),
    );
    
  }
}
