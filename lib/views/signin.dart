import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/signup.dart';
import 'package:ecommerce_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signIn extends StatefulWidget {
  @override
  final Function toggle;
  signIn(this.toggle);
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController =
      new TextEditingController();

  TextEditingController passwordTextEditingController =
      new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Helperfunctions helperfunctions = new Helperfunctions();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool obscure_Text = true;
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  void obscureText () async{
    setState(() {
      obscure_Text = !obscure_Text;
    });
  }
  saveSharedPreference (String userName,String userEmail)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("USERNAMEKEY", userName);
  }

  signIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      databaseMethods
          .getUserbyUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        saveSharedPreference(snapshotUserInfo.documents[0].data["name"],snapshotUserInfo.documents[0].data["email"]);
        Info.user_Name=snapshotUserInfo.documents[0].data["name"];
        Info.user_email=snapshotUserInfo.documents[0].data["email"];
        Info.customer =snapshotUserInfo.documents[0].data["customer"];
        Info.storeName=snapshotUserInfo.documents[0].data["storeName"];
        Constants.myName=Info.user_Name;
      });
      setState(() {
        isLoading = true;
      });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          Constants.myName=Info.user_Name;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => homeCustomer(Info.customer)));

        }
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Ecommerce",
          style: TextStyle(color: Colors.white),
        )),
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - 30,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+")
                                    .hasMatch(val)
                                ? null
                                : "Provide a valid Email Id";
                          },
                          controller: emailTextEditingController,
                          style: textStyle(),
                          decoration: textFieldInputDecoration("Email")),
                      TextFormField(
                          obscureText: obscure_Text,
                          validator: (val) {
                            return val.isNotEmpty || val.length > 6
                                ? null
                                : "Please provide a valid Password with 6+ character";
                          },
                          controller: passwordTextEditingController,
                          style: textStyle(),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: TextButton(
                              child: obscure_Text ? Text("Show") : Text("Hide"),
                              onPressed: () => obscureText(),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "Check Your Registered Email");
                    _auth.sendPasswordResetEmail(
                        email: emailTextEditingController.text);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Text("Forgot Password?", style: textStyle()),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Color(0xFFD15247),
                          borderRadius: BorderRadius.circular(19)),
                      child: Text("Sign In", style: TextStyle(color: Colors.white))),
                ),
                SizedBox(height: 16),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: textStyle1(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => (signUp(widget.toggle))));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Create now",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        )));
  }
}
