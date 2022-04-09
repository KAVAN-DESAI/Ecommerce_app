import 'dart:ffi';

import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/home.dart';
import 'package:ecommerce_app/views/productDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class myProduct extends StatefulWidget {
  @override
  _myProductState createState() => _myProductState();
}

class _myProductState extends State<myProduct> {
  @override
  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Helperfunctions helperfunctions = new Helperfunctions();

  Stream productStream;

  Widget myProductList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("products").where("storeName", isEqualTo: Info.storeName)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            scrollDirection: Axis.vertical,
            reverse: true,
            itemBuilder: (context, index) {
              bool isAddedToCart=false;
              List<dynamic> cartList= snapshot.data.documents[index].data["cartList"];
              final index1 = cartList.indexWhere((element) => element == Info.user_Name);
              if(index1>=0){
                isAddedToCart=true;
              }
              return ProductBlock(
                details: snapshot.data.documents[index].data["details"],
                imageUrl: snapshot.data.documents[index].data["imageUrl"],
                title: snapshot.data.documents[index].data["title"],
                price: snapshot.data.documents[index].data["price"],
                rating: snapshot.data.documents[index].data["rating"],
                isAddedToCart: isAddedToCart,
                cartList: snapshot.data.documents[index].data["cartList"],
              );
            })
            : Container();
      },
    );
  }

  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(30,0,30,0),
      child: myProductList(),
    );
  }
}