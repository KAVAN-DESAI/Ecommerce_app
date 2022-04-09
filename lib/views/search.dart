import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/helper/helperfunction.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/views/cart.dart';
import 'package:ecommerce_app/views/homeCustomer.dart';
import 'package:ecommerce_app/views/productDetails.dart';
import 'package:ecommerce_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class SearchPlatform extends StatefulWidget {
  @override
  _SearchPlatformState createState() => _SearchPlatformState();
}

class _SearchPlatformState extends State<SearchPlatform> {

  var queryResultSet=[];
  var tempSearchStore=[];

  TextEditingController searchTextEditingcontroller =
  new TextEditingController();
  Helperfunctions helperfunctions = new Helperfunctions();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;
  QuerySnapshot snapshotUserInfo;

  initaiteSearch(){
    databaseMethods
        .getProductbySearchKey(searchTextEditingcontroller.text)
        .then((val) async {
      print(val.toString());
      setState(() {
        searchSnapshot = val;
        print(searchSnapshot);
        print(searchSnapshot.documents.length);
      });
    });
  }


  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          bool isAddedToCart=false;
          List<dynamic> cartList= searchSnapshot.documents[index].data["cartList"];
          final index1 = cartList.indexWhere((element) => element == Info.user_Name);
          if(index1>=0){
            isAddedToCart=true;
          }
          print(searchSnapshot.documents[index].data["title"]);
          return ProductBlockSearch(
            details: searchSnapshot.documents[index].data["details"],
            imageUrl: searchSnapshot.documents[index].data["imageUrl"],
            title: searchSnapshot.documents[index].data["title"],
            price: searchSnapshot.documents[index].data["price"],
            rating: searchSnapshot.documents[index].data["rating"],
            isAddedToCart: isAddedToCart,
            cartList: searchSnapshot.documents[index].data["cartList"],
            category: searchSnapshot.documents[index].data["category"],
          );
        })
        : Container();
  }

  Widget searchTile({String storeName, String details, String imageUrl,String title,String price,String rating, List cartList}) {
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

  String searchString;

  @override
  Future<bool> _onBackPressed() {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homeCustomer(Info.customer)));
  }
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
      body:
      Container(
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          searchString=value.toLowerCase();
                          initaiteSearch();
                        });
                      },
                      controller: searchTextEditingcontroller,
                      decoration: textFieldInputDecoration("Search Product"),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  GestureDetector(
                    // onTap: () {
                    //   initaiteSearch();
                    // },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color(0xFF8F48F7),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search,color: Colors.white,),
                  ),)
                ],
              ),
            ),
            Expanded(child: searchList(),
            )
          ])),
    ));
  }
}


class ProductBlockSearch extends StatefulWidget {
  final String details;
  final String imageUrl;
  final String title;
  final String price;
  final bool isAddedToCart;
  final List cartList;
  final String rating;
  final String category;
  ProductBlockSearch(
      {this.details,
        this.imageUrl,
        this.title,
        this.price,
        this.isAddedToCart,
        this.cartList,
        this.rating,
        this.category});

  @override
  _ProductBlockSearchState createState() => _ProductBlockSearchState();
}

class _ProductBlockSearchState extends State<ProductBlockSearch> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget build(BuildContext context) {
    print(widget.title);
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 250,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
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
                Column(
                children: [
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
                      // Text(
                      //   widget.category,
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ), //Text//SizedBox
                ],
              ),
            ]), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    );
  }
}
