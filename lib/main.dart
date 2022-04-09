import 'package:ecommerce_app/authenticates.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  bool isLoggedIn=false;
  getSharedPref()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Info.user_Name = prefs.getString("USERNAMEKEY");
    var doc_ref=await Firestore.instance.collection("users").where("name", isEqualTo: Info.user_Name).getDocuments();
    doc_ref.documents.forEach((result) {
      Info.user_email=result.data["email"];
      Info.customer=result.data["customer"];
      Info.newItem=false;
      Info.customer?Info.storeName=result.data["storeName"]:Info.storeName="none";
      isLoggedIn=true;
    });
  }
  Widget build(BuildContext context) {
    getSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce',
      theme: ThemeData(
        primaryColor: Color(0xFFD15247),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      isLoggedIn ? homeCustomer(Info.customer): Authenticate(),
    );
  }
}