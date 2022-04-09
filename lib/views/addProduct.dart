import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/views/home.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import "package:firebase_storage/firebase_storage.dart";
import "package:image_picker/image_picker.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widget//widget.dart';
import 'package:ecommerce_app/services/database.dart';
import "dart:io";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class addProduct extends StatefulWidget {

  @override
  _addProductState createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  DatabaseMethods methods = new DatabaseMethods();
  TextEditingController Titlecontroller = new TextEditingController();
  TextEditingController Description = new TextEditingController();
  TextEditingController ratingContoller = new TextEditingController();
  TextEditingController priceContoller = new TextEditingController();
  TextEditingController categoryContoller = new TextEditingController();
  // Stream get_Im;
  File image;
  String image_Url = 'null'; //
  String x;
  int like = 0;
  List<dynamic> Group_like = ["empty"];
  // Future getImage(ImageSource source) async {
  //   var img = await ImagePicker.pickImage(source: source);
  //   setState(() {
  //     image = img;
  //     // image = img;
  //   });
  //   if (image != null) {
  //     var profileImage = FirebaseStorage.instance.ref().child(image.path);
  //     var task = profileImage.putFile(image);
  //     image_Url = await (await task.onComplete).ref.getDownloadURL();
  //     Fluttertoast.showToast(msg: "Now You can click on submit  ");
  //   }
  // }
  List fileName;
  var task;
  Future getImage(ImageSource source) async {
    var img = await ImagePicker.pickImage(source: source);
    setState(() {
      image = img;
      // image = img;
    });
    if (image != null) {
      String filePlace = image.path
          .replaceAll('/', ' ')
          .replaceAll("image_picker", "Ecommerce");
      fileName = filePlace.split(" ");
      _showMyDialog(fileName);

    }
  }
  Future<void> _showMyDialog(List fileName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Text('Share the below file to ${widget.user_name}?'),
                Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel'),
              onPressed: () {
                image = null;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('attach'),
              onPressed: ()async {
                Navigator.of(context).pop();
                uploadToStorage(fileName, image);
              },
            ),
          ],
        );
      },
    );
  }
  Future uploadToStorage(List fileName, File file) async {
    var profileImage = FirebaseStorage.instance.ref().child('groupFile')
        .child('/${fileName[fileName.length - 1]}');
    var task = profileImage.putFile(image);
    if (task != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  StreamBuilder<StorageTaskEvent>(
                      stream: task.events,
                      builder: (context, snapshot) {
                        var event = snapshot?.data?.snapshot;

                        double progressPercentIndicator = event != null
                            ? event.bytesTransferred / event.totalByteCount
                            : 0;
                        print(progressPercentIndicator);

                        return Column(
                          children: [
                            if (task.isComplete) Text('file is attach'),
                            LinearProgressIndicator(
                                value: progressPercentIndicator),
                            Text(
                                "${(progressPercentIndicator * 100).toStringAsFixed(2)}%")
                          ],
                        );
                      })
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ok'),
                onPressed: () async {
                  image_Url = await (await task.onComplete).ref.getDownloadURL();
                  setState(() {
                    image_Url = image_Url;

                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  submit(BuildContext context) async {
    print(image_Url);
    if (Titlecontroller.text.isNotEmpty && Description.text.isNotEmpty && image_Url != "null"){
      List searchKey=[];
      String temp="";
      searchKey.add(temp);
      for(int i=0;i<Titlecontroller.text.length;i++){
        temp+=Titlecontroller.text[i];
        searchKey.add(temp.toLowerCase());
      }
      Map<String, dynamic> groupMap = {
        "title": Titlecontroller.text,
        "date":
        FieldValue.serverTimestamp(), //FieldValue.serverTimestamp(),
        "cartList":['none'],
        "searchKey": searchKey,
        "imageUrl": image_Url,
        "price": priceContoller.text,
        "rating": ratingContoller.text,
        "details": Description.text,
        "category":categoryContoller.text,
      };
      await methods.addProduct(groupMap, Titlecontroller.text);
      Fluttertoast.showToast(msg: "Your group has been Added");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => (homeCustomer(Info.customer))));
    } else {
      Fluttertoast.showToast(msg: "Please fill all the field");
    }
  }
  Future<bool> _onBackPressed() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => homeCustomer(Info.customer)));
  }

  @override
  Widget build(BuildContext context) {
    print("aaaaaaaaaaaaaaaa");
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.all(6.0),
              child: new ListView(children: <Widget>[
                Column(children: [
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                            //padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: false,
                              maxLength: 23,
                              maxLines: 1,
                              controller: Titlecontroller,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "title",
                                  hintText: 'Enter Title ',
                                  prefixIcon: Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                          Container(
                            margin:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                            //padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: false,
                              maxLength: 23,
                              maxLines: 1,
                              controller: priceContoller,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "price",
                                  hintText: 'Enter price ',
                                  prefixIcon: Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                          Container(
                            margin:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                            //padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: false,
                              maxLength: 23,
                              maxLines: 1,
                              controller: ratingContoller,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "rating",
                                  hintText: 'Enter rating ',
                                  prefixIcon: Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            //padding: const EdgeInsets.all(1.0),
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: false,
                              maxLength: 250,
                              maxLines: 6,
                              controller: Description,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: 'Enter group description ',
                                  prefixIcon: Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                          Container(
                            margin:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                            //padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: false,
                              maxLength: 23,
                              maxLines: 1,
                              controller: categoryContoller,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "category",
                                  hintText: 'Enter category ',
                                  prefixIcon: Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[200])),
                              child: Row(
                                children: [Icon(Icons.image), Text("Add an image")],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  image_Url != 'null' ? Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200])),
                      height: MediaQuery.of(context).size.height/3,
                      width : MediaQuery.of(context).size.width*2/3,
                      child:Image.network(image_Url,fit:BoxFit.cover)
                  ):Container(),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 10.0),
                  ),
                  RaisedButton(
                    onPressed: (){
                      print("its here");
                      submit(context);
                    },
                    child: Text("Add group"),
                    elevation: 5.0,
                  ),
                ]),
              ]),
            ),
          ),
        ));
  }
}