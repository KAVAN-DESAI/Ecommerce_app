import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/productList.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class productDetails extends StatefulWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final String rating;
  final List cartList;
  productDetails(
       this.details, this.imageUrl, this.title, this.price,this.rating,this.cartList);
  @override
  _productDetailsState createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  @override
  Widget post(String picture) {
    if (picture != "null") {
      return Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          picture,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

    Future<bool> _onBackPressed() {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => productListView()));
    }
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:
      Scaffold(
        appBar: AppBar(
            actions: [
              Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Info.newItem
                      ? Icon(
                          Icons.shopping_cart,
                          color: Colors.orange,
                          size: 35,
                        )
                      : Icon(Icons.shopping_cart,
                          color: Colors.white, size: 35)),
            ],
            title: Text(
              "Ecommerce",
              style: TextStyle(color: Colors.white),
            )),
        body: SafeArea(
          child: ListView(
            children: [
              Container(child: post(widget.imageUrl)),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: double.parse(widget.rating),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // rating=
                      },
                    ),
                    Text(
                      "Title: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "\t" + "\t" + widget.title,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      "Date: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "Time: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "\t" + "\t" + widget.price,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                      alignment: Alignment.centerRight,
                      width: 10,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          Firestore.instance
                              .collection("products")
                              .document(widget.title)
                              .delete();
                          Fluttertoast.showToast(msg: "Product Deleted");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        homeCustomer(Info.customer)));
                        },
                        child: Text("Delete Event",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
              Divider(),
              Text(
                "About: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "\t" + "\t" + widget.details,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )),
              Divider(),
              Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomCenter,
                width: 10,
                height: 70,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Info.newItem = true;
                    Map<String, dynamic> productMap =
                        new Map<String, dynamic>();
                    productMap = {
                      "title": widget.title,
                      "details": widget.details,
                      "price": widget.price,
                      "imageUrl": widget.imageUrl,
                      "cartList": widget.cartList,
                      "rating": widget.rating,
                    };
                    widget.cartList.add(Info.user_Name);
                    databaseMethods.updateCart(productMap,widget.title,widget.cartList,Info.user_Name);
                    Fluttertoast.showToast(msg: "Added to Cart");
                  },
                  child: Text("Add To Cart",
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
              )
            ],
          ),
        )));
  }
}
