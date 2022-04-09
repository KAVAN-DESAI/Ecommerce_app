import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/productDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  @override
  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Helperfunctions helperfunctions = new Helperfunctions();

  Stream productStream;

  Widget cartProductList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("users").document(Info.user_Name).collection("cart")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            reverse: true,
            itemBuilder: (context, index) {
              bool isAddedToCart=false;
              List<dynamic> cartList= snapshot.data.documents[index].data["cartList"];
              final index1 = cartList.indexWhere((element) => element == Info.user_Name);
              if(index1>=0){
                isAddedToCart=true;
              }
              return ProductBlockSearch(
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
    Future<bool> _onBackPressed() {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => homeCustomer(Info.customer)));
    }
    return WillPopScope(
        onWillPop: _onBackPressed,
      child:Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cart",style: TextStyle(color: Colors.black),),
              GestureDetector(
                onTap: (){
                  Firestore.instance.collection("user").document(Info.user_Name).collection("cart").getDocuments().then( (snapshot) {
                    for (DocumentSnapshot doc in snapshot.documents) {
                      doc.reference.delete();
                    };
                  });
                },
                child: Container(
                  width: 150,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black,
                  ),
                    child: Text("Checkout",style: TextStyle(color: Colors.white),)
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
        ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30,0,30,0),
        child: cartProductList(),
      ),
    ));
  }
}


class cartProductBlock extends StatelessWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final bool isAddedToCart;
  final List cartList;
  final String rating;
  cartProductBlock({ this.details,this.imageUrl,this.title,this.price,this.isAddedToCart,this.cartList,this.rating});
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => productDetails(details,imageUrl,title,price, rating,cartList)));
        },
        child: GFCard(
          boxFit: BoxFit.cover,
          imageOverlay: AssetImage('your asset image'),
          title: GFListTile(
            avatar: Container(
              width: 55,
              child: Container(
                child: CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            subTitle: Text(details),
          ),
        ),
      ),
    );
  }
}
