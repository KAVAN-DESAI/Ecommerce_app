import 'package:ecommerce_app/authenticates.dart';
import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:flutter/material.dart';
class userProfile extends StatelessWidget {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:250),
      child: GestureDetector(
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app, color: Colors.white,),
                ),
                Container(
                  child: Text("LogOut", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
          )),
    );
  }
}
