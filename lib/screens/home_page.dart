import 'dart:convert';
import 'package:ecommerceapp/models/user.dart';
import 'package:ecommerceapp/screens/cart_page.dart';
import 'package:ecommerceapp/screens/Vendor/delete_page.dart';
import 'package:ecommerceapp/screens/user_page.dart';
import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'Vendor/add_product_page.dart';
import 'Vendor/edit_page.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin {
  var data;
  ScrollController scrollController;
  bool _isLoading = false;
  ProductService _productService = ProductService();
  bool dialVisible = true;

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    loadData().then((value) {
      print(widget.user.name);
      setState(() {
        _isLoading = false;
      });
    });
    _productService.getLatestID(widget.user.authToken);
    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    final listResponse = await http.get(
      "https://kicksup.herokuapp.com/products",
    );
    if (listResponse.statusCode == 200) {
      var listData = jsonDecode(listResponse.body);
      data = listData;
      setState(() {
        _isLoading = false;
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Kicks Up"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Tooltip(child: Icon(Icons.person), message: "Profile"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(user: widget.user)));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
                child: Tooltip(child: Icon(Icons.shopping_cart), message: "Cart"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(
                                user: widget.user,
                              )));
                }),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: data == null ? 0 : data.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          var listItemData = Product.fromJson(data[index]);
                          var _color;
                          if (listItemData.color == "blue")
                            _color = Colors.blue;
                          else if (listItemData.color == "white")
                            _color = Colors.white;
                          else if (listItemData.color == "green")
                            _color = Colors.green;
                          else if (listItemData.color == "black") _color = Colors.black;
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(listItemData.brand, style: TextStyle(fontSize: 30)),
                                        SizedBox(width: 10),
                                        Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: _color,
                                              shape: BoxShape.circle,
                                            )),
                                        Expanded(flex: 2, child: SizedBox(width: 10)),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            _productService.addToCart(listItemData.id, widget.user.authToken);
                                          },
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(listItemData.gender),
                                        Text("\$" + listItemData.price.toString(),
                                            style: TextStyle(fontSize: 20, color: Colors.green))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed: () {
//            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage(authToken: widget.user.authToken,))).then((value) => loadData());
//          }),
      floatingActionButton: buildSpeedDial()
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
       child: Icon(Icons.add),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage(authToken: widget.user.authToken))).then((value) => loadData()),
          label: 'Add product',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blue,
        ),
        SpeedDialChild(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage())).then((value) => loadData()),
          label: 'Edit price',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.delete, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DeletePage())).then((value) => loadData()),
          label: 'Delete Product',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.red,
        ),
      ],
    );
  }
}
