import 'package:ecommerce_app/helper/constants.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/views/cart.dart';
import 'package:ecommerce_app/views/home.dart';
import 'package:ecommerce_app/views/myProduct.dart';
import 'package:ecommerce_app/views/profile.dart';
import 'package:ecommerce_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class homeCustomer extends StatefulWidget {
  @override
  final bool isCustomer;
  homeCustomer(this.isCustomer);
  _homeCustomerState createState() => _homeCustomerState();
}

class _homeCustomerState extends State<homeCustomer> {
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
    cart(),
    userProfile(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(elevation: 0, backgroundColor: Color(0xFFD15247), actions: [
        Padding(
          padding: EdgeInsets.only(top: 10, right: 20,bottom: 5),
          child: Center(
            child:(_selectedTabIndex==1 || _selectedTabIndex==2)? Container():  GestureDetector(
              onTap: (){
                setState(() {
                  _selectedTab = _SelectedTab.values[1];
                  _selectedTabIndex=1;
                });
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
            child: Icon(Icons.shopping_cart, color: Colors.white,size: 30)
        )
      ]),
      body: listScreens[_selectedTabIndex],
      bottomNavigationBar:  DotNavigationBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        marginR : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        backgroundColor: Colors.grey[300],
        onTap: _handleIndexChanged,
        // dotIndicatorColor: Colors.black,
        enableFloatingNavBar: true,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.purple,
          ),

          /// Likes
          DotNavigationBarItem(
            icon: Icon(Icons.search),
            selectedColor: Colors.pink,
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            selectedColor: Colors.orange,
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(Icons.person),
            selectedColor: Colors.teal,
          ),

        ],
      ),
    );
  }
}

enum _SelectedTab { home, search, order, person }