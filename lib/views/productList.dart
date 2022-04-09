import 'dart:ffi';

import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/cart.dart';
import 'package:ecommerce_app/views/home.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/myProduct.dart';
import 'package:ecommerce_app/views/productDetails.dart';
import 'package:ecommerce_app/views/profile.dart';
import 'package:ecommerce_app/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hover_effect/hover_effect.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class productListView extends StatefulWidget {
  @override
  _productListViewState createState() => _productListViewState();
}

class _productListViewState extends State<productListView> {
  @override

  var _selectedTab = _SelectedTab.home;
  int _selectedTabIndex=0;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      _selectedTabIndex=i;
    });
  }

  List<Widget> listScreens = [
    home(),
    SearchPlatform(),
    myProduct(),
    userProfile(),
  ];
  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Helperfunctions helperfunctions = new Helperfunctions();

  Stream productStream;

  Widget productList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("products")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              bool isAddedToCart=false;
              List<dynamic> cartList= snapshot.data.documents[index].data["cartList"];
              final index1 = cartList.indexWhere((element) => element == Info.user_Name);
              if(index1>=0){
                isAddedToCart=true;
              }
              return productBlock(
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

  Future<bool> _onBackPressed() {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => homeCustomer(Info.customer)));
  }

  Widget build(BuildContext context) {
    PageController page = PageController();
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:
        Scaffold(
          extendBody: true,
          appBar: AppBar(elevation: 0, backgroundColor: Colors.white, actions: [
            Padding(
              padding: EdgeInsets.only(top: 10, right: 20,bottom: 5),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (context) => homeCustomer(Info.customer)));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width -70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]),
                    child: Row(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10,
                            right: MediaQuery.of(context).size.width - 155),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Search",
                                style: TextStyle(color: Colors.grey))),
                      ),
                      Icon(Icons.search, color: Colors.grey)
                    ]),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => cart()));
                },
                child: Icon(Icons.shopping_cart, color: Colors.black,size: 30)
            )
          ]),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10,10,10,10),
        child: productList(),
      ),
          // bottomNavigationBar:  DotNavigationBar(
          //   currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          //   marginR : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          //   backgroundColor: Colors.grey[300],
          //   onTap: _handleIndexChanged,
          //   // dotIndicatorColor: Colors.black,
          //   enableFloatingNavBar: true,
          //   items: [
          //     /// Home
          //     DotNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       selectedColor: Colors.purple,
          //     ),
          //
          //     /// Likes
          //     DotNavigationBarItem(
          //       icon: Icon(Icons.search),
          //       selectedColor: Colors.pink,
          //     ),
          //
          //     /// Search
          //     DotNavigationBarItem(
          //       icon: Icon(Icons.receipt_long_rounded),
          //       selectedColor: Colors.orange,
          //     ),
          //
          //     /// Profile
          //     DotNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       selectedColor: Colors.teal,
          //     ),
          //
          //   ],
          // ),
    ));
  }
}


class productBlock extends StatelessWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final bool isAddedToCart;
  final List cartList;
  final String rating;
  productBlock({ this.details,this.imageUrl,this.title,this.price,this.isAddedToCart,this.cartList,this.rating});
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => productDetails(details,imageUrl,title,price, rating,cartList)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.purpleAccent[50],
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: Colors.blue.withOpacity(1) , width: .8)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: MediaQuery.of(context).size.height/4,
                fit: BoxFit.contain,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 25.0, fontFamily: "Raleway")),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Text("Rating"),
                      SizedBox(
                        width: 80,
                        child: RatingBar.builder(
                          initialRating: double.parse(  rating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 10.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            // rating=
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(price.toString(),
                          style:
                          TextStyle(fontSize: 28.0, fontFamily: "Helvetica")),
                    ],
                  ),
                  IconButton(
                    icon: isAddedToCart? Icon(Icons.add_shopping_cart,color: Colors.orange,): Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      if(!isAddedToCart) {
                        Info.newItem = true;
                        Map<String, dynamic> productMap =
                        new Map<String, dynamic>();
                        productMap = {
                          "title": title,
                          "details": details,
                          "price": price,
                          "imageUrl": imageUrl,
                          "cartList": cartList,
                          "rating": rating,
                        };
                        cartList.add(Info.user_Name);
                        databaseMethods.updateCart(productMap, title, cartList,Info.user_Name);
                        Fluttertoast.showToast(msg: "Added to Cart");
                      }
                      else{
                        Fluttertoast.showToast(msg: "Already Added to Cart");
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}


class _IconTile extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;

  const _IconTile(
      {key, this.width,
        this.height,
        this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xff645478),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Icon(
        iconData,
        color: Color(0xffAEA6B6),
      ),
    );
  }
}

class _ItemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Container(
              width: 60,
              height: 60,
              color: Color(0xff9783A9),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xff6D528D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: _RowPlaceholder(color: 0xffA597B4),
                      width: MediaQuery.of(context).size.width * 2 / 5,
                    ),
                    _RowPlaceholder(color: 0xff846CA1),
                    _RowPlaceholder(color: 0xff846CA1),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RowPlaceholder extends StatelessWidget {
  final int color;

  const _RowPlaceholder({ key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}

enum _SelectedTab { home, search, order, person }