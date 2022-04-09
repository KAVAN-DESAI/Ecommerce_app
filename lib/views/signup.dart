import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/signin.dart';
import 'package:ecommerce_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';

class signUp extends StatefulWidget {
  @override
  final Function toggle;
  signUp(this.toggle);
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  @override

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  TextEditingController otpTextEditingController = new TextEditingController();
  TextEditingController storeNameTextEditingController = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Helperfunctions helperfunctions = new Helperfunctions();
  bool isLoading = false;
  bool obscure_Text = true;
  void obscureText () async{
    setState(() {
      obscure_Text = !obscure_Text;
    });
  }

  void verifyOTP() async {
    var response = EmailAuth.validate(receiverMail:  emailTextEditingController.text, userOTP: otpTextEditingController.text );
    if(response){
      okSignMUp();
    }
    else{
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  void addData(String name, String email){
    Info.user_Name= name;
    Info.user_email=email;
    Constants.myName=name;
  }

  okSignMUp() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
            addData(userNameTextEditingController.text,emailTextEditingController.text
        );
            DatabaseMethods.uploadUserInfo({"email": Info.user_email, "name": Info.user_Name, "customer": true},Info.user_Name);
            Info.customer=true;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => homeCustomer(Info.customer)));
      });
    }
  }

  void sendOTP () async{
    EmailAuth.sessionName = "Ecommerce";
    var response = await EmailAuth.sendOtp(receiverMail: emailTextEditingController.text);
    if (response){
      Fluttertoast.showToast(msg: "An OTP has been send on your email ");
    }
    else{
      Fluttertoast.showToast(msg: "Failed to send OTP. Please try again ");
    }
  }
  int indexSelected=0;

  Widget build(BuildContext context) {
    Info.customer=false;
    Info.newItem=false;
    return Scaffold(
      appBar:AppBar(
          title: Text(
            "Ecommerce",
            style: TextStyle(color: Colors.white),
          )),
      body: isLoading
          ? Container(
        child: Center(
            child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height -80,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 4
                                    ? "Please enter a valid User Name!"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: textStyle(),
                              decoration:
                              textFieldInputDecoration("username")),
                          TextFormField(
                              controller: emailTextEditingController,
                              style: textStyle1(),
                              validator: (val) {
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+")
                                // @ahduni.edu.in+")
                                    .hasMatch(val)
                                    ? null
                                    : "Provide a valid Email Id";
                              },
                              decoration: InputDecoration(hintText: "Email",
                                suffixIcon: TextButton(child: Text("Send OTP"),
                                  onPressed: () => sendOTP(),),
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors. black, width: 2.0),
                                  borderRadius: BorderRadius. circular(20.0),
                                ),
                              )),
                          TextFormField(
                              validator: (val) {
                                return val.length > 0
                                    ? null
                                    : "Please enter OTP";
                              },
                              controller: otpTextEditingController,
                              style: textStyle1(),
                              decoration: InputDecoration(hintText: "OTP",
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors. black, width: 2.0),
                                  borderRadius: BorderRadius. circular(20.0),
                                ),
                              )),
                          TextFormField(
                              obscureText: obscure_Text ,
                              validator: (val) {
                                return val.isNotEmpty || val.length > 6
                                    ? null
                                    : "Please provide a valid Password with 6+ character";
                              },
                              controller: passwordTextEditingController,
                              style: textStyle(),
                              decoration: InputDecoration(hintText: "Password",hintStyle: TextStyle(color: Colors.black), suffixIcon: TextButton(child: obscure_Text? Text("Show"):Text("Hide"),
                                onPressed: () => obscureText(),),
                                  focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)))),
                        ],
                      ),
                    ),
                    Container(
                        height:5
                    ),
                    GestureDetector(
                      onTap: () {
                        // okSignMUp();
                        verifyOTP();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Color(0xFFD15247),
                              borderRadius: BorderRadius.circular(19)),
                          child: Text("Next", style: TextStyle(color: Colors.white))),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account? ",
                          style: textStyle1(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => (signIn(widget.toggle))));
                          },
                          child: Text(
                            "SignIn now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
