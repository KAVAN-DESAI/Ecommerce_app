import 'dart:ffi';

import 'package:ecommerce_app/helper/auth.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/addProduct.dart';
import 'package:ecommerce_app/views/cart.dart';
import 'package:ecommerce_app/views/productDetails.dart';
import 'package:ecommerce_app/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Helperfunctions helperfunctions = new Helperfunctions();

  Stream trendingProductStream;

  Widget TrendingproductList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var rng = Random();
                  int ind=rng.nextInt(1000)%(snapshot.data.documents.length);
                  bool isAddedToCart = false;
                  List<dynamic> cartList =
                      snapshot.data.documents[ind].data["cartList"];
                  final index1 = cartList
                      .indexWhere((element) => element == Info.user_Name);
                  if (index1 >= 0) {
                    isAddedToCart = true;
                  }
                  return TrendingProductBlock(
                    details: snapshot.data.documents[ind].data["details"],
                    imageUrl: snapshot.data.documents[ind].data["imageUrl"],
                    title: snapshot.data.documents[ind].data["title"],
                    price: snapshot.data.documents[ind].data["price"],
                    rating: snapshot.data.documents[ind].data["rating"],
                    isAddedToCart: isAddedToCart,
                    cartList: snapshot.data.documents[ind].data["cartList"],
                    category: snapshot.data.documents[ind].data["category"],
                  );
                })
            : Container();
      },
    );
  }


  Widget productList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: min(snapshot.data.documents.length, 4),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool isAddedToCart = false;
              List<dynamic> cartList =
              snapshot.data.documents[index].data["cartList"];
              final index1 = cartList
                  .indexWhere((element) => element == Info.user_Name);
              if (index1 >= 0) {
                isAddedToCart = true;
              }
              return ProductBlock(
                details: snapshot.data.documents[index].data["details"],
                imageUrl: snapshot.data.documents[index].data["imageUrl"],
                title: snapshot.data.documents[index].data["title"],
                price: snapshot.data.documents[index].data["price"],
                rating: snapshot.data.documents[index].data["rating"],
                isAddedToCart: isAddedToCart,
                cartList: snapshot.data.documents[index].data["cartList"],
                category: snapshot.data.documents[index].data["category"],
              );
            })
            : Container();
      },
    );
  }

  Widget build(BuildContext context) {
    PageController page = PageController();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Divider(),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Find Your Desired Items",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Recomended Items For You",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green))),
            Expanded(child: productList()),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Trending Deals",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3db360)))),
            Expanded(
              child: TrendingproductList(),
            ),
            // Expanded(
            //   child: Padding(
            //       padding: EdgeInsets.fromLTRB(30,0,30,0),
            //       child: discounts,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => (addProduct())));
        },
      ),
    );
  }
}
class TrendingProductBlock extends StatefulWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final bool isAddedToCart;
  final List cartList;
  final String rating;
  final String category;
  TrendingProductBlock(
      {this.details,
        this.imageUrl,
        this.title,
        this.price,
        this.isAddedToCart,
        this.cartList,
        this.rating,
        this.category});

  @override
  _TrendingProductBlockState createState() => _TrendingProductBlockState();
}

class _TrendingProductBlockState extends State<TrendingProductBlock> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => productDetails(
                    widget.details,
                    widget.imageUrl,
                    widget.title,
                    widget.price,
                    widget.rating,
                    widget.cartList)));
      },
      child: Card(
        // elevation: 50,
        shadowColor: Colors.white,
        color: Color(0xFFD15247),
        child: Container(
          width: 180,
          height: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(children: <Widget>[
                  Positioned(
                    top: 1.0,
                    child: Icon(Icons.favorite),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    height: 150,
                    width: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Image border
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(50), // Image radius
                        child: Image.network(widget.imageUrl,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.softLight),
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title.substring(0,min(widget.title.length,15)),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ), //Textstyle
                    ),
                  ),
                    Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: (){
                            if(!widget.isAddedToCart) {
                              List cartListUpdated = widget.cartList;
                              cartListUpdated.add(Info.user_Name);
                              Map<String, dynamic> groupMap = {
                                "title": widget.title,
                                "date":
                                FieldValue.serverTimestamp(),
                                //FieldValue.serverTimestamp(),
                                "cartList": cartListUpdated,
                                "imageUrl": widget.imageUrl,
                                "price": widget.price,
                                "rating": widget.rating,
                                "details": widget.details,
                                "category": "Gadget",
                              };
                              Firestore.instance
                                  .collection("users")
                                  .document(Info.user_Name).collection("cart").add(
                                  groupMap);
                              Firestore.instance
                                  .collection("products")
                                  .document(widget.title).updateData(
                                  {"cartList": cartListUpdated  });
                            }
                          },
                          child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.isAddedToCart? Colors.yellow :Colors.white ,
                              ),
                              child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.black,)
                          ),
                        )
                    ),
                  ]
                ), //Text//SizedBox
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$ " + widget.price,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ), //Textstyle
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      widget.rating + " (34)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ), //Textstyle
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.category,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ), //Text//SizedBox
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    );
  }
}

class _IconTile extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;

  const _IconTile({key, this.width, this.height, this.iconData})
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



class ProductBlock extends StatefulWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final bool isAddedToCart;
  final List cartList;
  final String rating;
  final String category;

  ProductBlock({this.details,
        this.imageUrl,
        this.title,
        this.price,
        this.isAddedToCart,
        this.cartList,
        this.rating,
        this.category});

  @override
  _ProductBlockState createState() => _ProductBlockState();
}

class _ProductBlockState extends State<ProductBlock> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => productDetails(
                    widget.details,
                    widget.imageUrl,
                    widget.title,
                    widget.price,
                    widget.rating,
                    widget.cartList)));
      },
      child: Card(
        elevation: 50,
        shadowColor: Colors.white,
        color: Color(0xFFD15247),
        child: Container(
          width: 250,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(children: <Widget>[
                  Positioned(
                    top: 1.0,
                    child: Icon(Icons.favorite),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    height: 180,
                    width: 230,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Image border
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(100), // Image radius
                        child: Image.network(widget.imageUrl,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.softLight),
                      ),
                    ),
                  ),
                ]),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ),
                ), //Text//SizedBox
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$ " + widget.price,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ), //Textstyle
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.details.substring(0, min(50, widget.details.length)),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ), //Textstyle
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      widget.rating + " (34)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ), //Textstyle
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.category,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      height: 15,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        " Hand-Picked ",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ), //Text//SizedBox
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      if(!widget.isAddedToCart) {
                        List cartListUpdated = widget.cartList;
                        cartListUpdated.add(Info.user_Name);
                        Map<String, dynamic> groupMap = {
                          "title": widget.title,
                          "date":
                          FieldValue.serverTimestamp(),
                          //FieldValue.serverTimestamp(),
                          "cartList": ['none'],
                          "imageUrl": widget.imageUrl,
                          "price": widget.price,
                          "rating": widget.rating,
                          "details": widget.details,
                          "category": cartListUpdated,
                        };
                        Firestore.instance
                            .collection("users")
                            .document(Info.user_Name).collection("cart").add(
                            groupMap);
                        Firestore.instance
                            .collection("products")
                            .document(widget.title).updateData(
                            {"cartList": cartListUpdated  });
                      }
                    },
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.isAddedToCart? Colors.yellow :Colors.white ,
                      ),
                        child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.black,)
                    ),
                  )
                ),
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    );
  }
}


class _RowPlaceholder extends StatelessWidget {
  final int color;

  const _RowPlaceholder({key, this.color}) : super(key: key);

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
// GridView.count(
// // physics: NeverScrollableScrollPhysics(),
// childAspectRatio: 2 / 1.5,
// shrinkWrap: true,
// crossAxisCount: 2,
// children: List.generate(4, //this is the total number of cards
// (index) {
// if (index == 1) {
// return Container(
// child: Card(
// color: Colors.red[100],
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CircleAvatar(
// radius: 50,
// child: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(
// "assets/images/sides.jpeg"),
// fit: BoxFit.fill),
// color: Colors.white,
// shape: BoxShape.circle,
// ),
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// "Sides's",
// style: TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// fontSize: 15),
// ),
// // Divider(),
// // Text("PIZZA"),
// ],
// )
// ],
// ),
// ),
// );
// } else if (index == 2) {
// return Container(
// child: Card(
// color: Colors.green[100],
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CircleAvatar(
// radius: 50,
// child: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(
// "assets/images/pizzamania.jpeg"),
// fit: BoxFit.fill),
// color: Colors.white,
// shape: BoxShape.circle,
// ),
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// "Pizza Mania",
// style: TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// fontSize: 15),
// ),
// // Divider(),
// // Text("PIZZA"),
// ],
// )
// ],
// ),
// ),
// );
// } else if (index == 3) {
// return Container(
// child: Card(
// color: Colors.blue[100],
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CircleAvatar(
// radius: 50,
// child: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(
// "assets/images/desert.jpeg"),
// fit: BoxFit.fill),
// color: Colors.white,
// shape: BoxShape.circle,
// ),
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// "Dessert's",
// style: TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// fontSize: 15),
// ),
// // Divider(),
// // Text("PIZZA"),
// ],
// )
// ],
// ),
// ),
// );
// } else if (index == 0) {
// return Container(
// child: Card(
// color: Colors.yellow[100],
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CircleAvatar(
// radius: 50,
// child: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(
// "assets/images/pizza.jpeg"),
// fit: BoxFit.fill),
// color: Colors.white,
// shape: BoxShape.circle,
// ),
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// "Pizza's",
// style: TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// fontSize: 15),
// ),
// // Divider(),
// // Text("PIZZA"),
// ],
// )
// ],
// ),
// ),
// );
// }
// }),
// ),