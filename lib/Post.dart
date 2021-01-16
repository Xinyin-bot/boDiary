  import 'package:food_ninja/user.dart';

class Post {
String postid,
       username,
       postimage,
       postcaption,
       postdate,
       postcomment;
       User users;

  Post(
      {
    this.postid,
    this.username,
    this.postimage,
    this.postcaption,
    this.postdate,
    this.postcomment});
}
