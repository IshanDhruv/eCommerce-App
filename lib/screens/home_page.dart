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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List data;
  ScrollController scrollController;
  bool _isLoading = false;
  ProductService _productService = ProductService();
  bool dialVisible = true;
  final _priceKey = GlobalKey<FormState>();
  final _colorKey = GlobalKey<FormState>();
  double _maxPrice = double.maxFinite;
  double _minPrice = 0;
  List _deciderColor = [];
  List brands = [];
  List _deciderBrands = [];
  List genders = [];
  List _deciderGenders = [];
  bool _sortedAscending = true;

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
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
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
      for (var item in data) {
        if (!brands.contains(item["brand"])) brands.add(item["brand"]);
        if (!genders.contains(item["gender"].toLowerCase())) genders.add(item["gender"]);
      }
      print(genders);
      setState(() {
        _isLoading = false;
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    void sortDataAscending() {
      setState(() {
        try {
          data.sort((a, b) {
            return a["price"].compareTo(b["price"]);
          });
        } catch (e) {
          print(e);
        }
        _sortedAscending = true;
      });
    }

    void sortDataDescending() {
      setState(() {
        try {
          data.sort((b, a) {
            return a["price"].compareTo(b["price"]);
          });
        } catch (e) {
          print(e);
        }
        _sortedAscending = false;
      });
    }

    Widget priceForm() {
      return Form(
        key: _priceKey,
        child: Column(
          children: <Widget>[
            Text("Set price range"),
            SizedBox(height: 20),
            TextFormField(
              initialValue: _minPrice == 0 ? null : _minPrice.floor().toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Min Price", border: OutlineInputBorder()),
              onChanged: (val) {
                setState(() {
                  return val == null ? _minPrice = 0 : _minPrice = double.parse(val);
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: _maxPrice == double.maxFinite ? null : _maxPrice.floor().toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Max Price", border: OutlineInputBorder()),
              onChanged: (val) {
                setState(() {
                  return val == null ? _maxPrice = double.maxFinite : _maxPrice = double.parse(val);
                });
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text("CLEAR"),
              color: Colors.red,
              onPressed: () {
                if (_priceKey.currentState.validate()) {
                  setState(() {
                    _minPrice = 0;
                    _maxPrice = double.maxFinite;
                  });
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      );
    }

    void showPricePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 60),
              child: priceForm(),
            );
          });
    }

    void showColorPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              Widget _colorBox(String _colorName, Color _color) {
                return GestureDetector(
                  onTap: () {
                    if (_deciderColor.contains(_colorName)) {
                      setState(() => _deciderColor.remove(_colorName));
                      state(() => _deciderColor.remove(_colorName));
                    } else {
                      setState(() => _deciderColor.add(_colorName));
                      state(() => _deciderColor.add(_colorName));
                    }
                  },
                  child: _deciderColor.contains(_colorName)
                      ? Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(color: _color, border: Border.all(color: Colors.yellow)),
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          color: _color,
                        ),
                );
              }

              Widget _brandBox(String _brandName) {
                return GestureDetector(
                  onTap: () {
                    if (_deciderBrands.contains(_brandName)) {
                      setState(() => _deciderBrands.remove(_brandName));
                      state(() => _deciderBrands.remove(_brandName));
                    } else {
                      setState(() => _deciderBrands.add(_brandName));
                      state(() => _deciderBrands.add(_brandName));
                    }
                  },
                  child: _deciderBrands.contains(_brandName)
                      ? Container(
                          color: Colors.blue,
                          child: Text(_brandName, style: TextStyle(fontSize: 25)),
                        )
                      : Container(
                          child: Text(_brandName, style: TextStyle(fontSize: 25)),
                        ),
                );
              }
              var brandRow = List<Widget>();
              for (var item in brands) {
                brandRow.add(_brandBox(item));
              }

              Widget _genderBox(String _gender) {
                return GestureDetector(
                  onTap: () {
                    if (_deciderGenders.contains(_gender)) {
                      setState(() => _deciderGenders.remove(_gender));
                      state(() => _deciderGenders.remove(_gender));
                    } else {
                      setState(() => _deciderGenders.add(_gender));
                      state(() => _deciderGenders.add(_gender));
                    }
                  },
                  child: _deciderGenders.contains(_gender)
                      ? Container(
                    color: Colors.blue,
                    child: Text(_gender, style: TextStyle(fontSize: 25)),
                  )
                      : Container(
                    child: Text(_gender, style: TextStyle(fontSize: 25)),
                  ),
                );
              }
              var genderRow = List<Widget>();
              for (var item in genders) {
                genderRow.add(_genderBox(item));
              }

              return Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Form(
                  key: _colorKey,
                  child: Column(
                    children: <Widget>[
                      Text("Select Colors", style: TextStyle(fontSize: 40)),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _colorBox('white', Colors.white),
                          _colorBox('yellow', Colors.yellow),
                          _colorBox('orange', Colors.orange),
                          _colorBox('red', Colors.red)
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _colorBox('teal', Colors.teal),
                          _colorBox('green', Colors.green),
                          _colorBox('blue', Colors.blue),
                          _colorBox('black', Colors.black),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: brandRow,
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: genderRow,
                      ),
                      SizedBox(height: 40),
                      RaisedButton(
                        child: Text("CLEAR"),
                        color: Colors.red,
                        onPressed: () {
                          if (_colorKey.currentState.validate()) {
                            setState(() {
                              _deciderColor = [];
                            });
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            });
          });
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
              child: Text("Kicks Up"),
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(user: widget.user)))),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                  child: Tooltip(child: Icon(Icons.color_lens), message: "Choose color"),
                  onTap: () => showColorPanel()),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                  child: Tooltip(child: Icon(Icons.attach_money), message: "Set price range"),
                  onTap: () => showPricePanel()),
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
            : (_maxPrice < _minPrice)
                ? Center(child: Text("Maximum price cannot be less than minimum price!"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: _sortedAscending ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
                              onPressed: () {
                                if (_sortedAscending)
                                  sortDataDescending();
                                else
                                  sortDataAscending();
                              },
                            )),
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: data == null ? 0 : data.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, int index) {
                                var listItemData = Product.fromJson(data[index]);
                                var _color;
                                listItemData.color = listItemData.color.toLowerCase();
                                listItemData.gender = listItemData.gender.toLowerCase();
                                if (listItemData.color == "blue")
                                  _color = Colors.blue;
                                else if (listItemData.color == "white")
                                  _color = Colors.white;
                                else if (listItemData.color == "green")
                                  _color = Colors.green;
                                else if (listItemData.color == "black")
                                  _color = Colors.black;
                                else if (listItemData.color == "red")
                                  _color = Colors.red;
                                else if (listItemData.color == "yellow")
                                  _color = Colors.yellow;
                                else if (listItemData.color == "orange")
                                  _color = Colors.orange;
                                else if (listItemData.color == "purple") _color = Colors.purple;
                                if (_minPrice == null) _minPrice = 0;
                                if (_maxPrice == null) _maxPrice = double.maxFinite;
                                if (listItemData.price >= _minPrice && listItemData.price <= _maxPrice) {
                                  if (_deciderColor.isEmpty || _deciderColor.contains(listItemData.color)) {
                                    if (_deciderBrands.isEmpty || _deciderBrands.contains(listItemData.brand)) {
                                      if (_deciderGenders.isEmpty || _deciderGenders.contains(listItemData.gender)) {
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
                                                          _productService.addToCart(
                                                              listItemData.id, widget.user.authToken);
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
                                      } else
                                        return Container();
                                    } else
                                      return Container();
                                  } else
                                    return Container();
                                } else
                                  return Container();
                              }))
                    ],
                  ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed: () {
//            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage(authToken: widget.user.authToken,))).then((value) => loadData());
//          }),
        floatingActionButton: buildSpeedDial());
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
          onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddProductPage(authToken: widget.user.authToken)))
              .then((value) => loadData()),
          label: 'Add product',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blue,
        ),
        SpeedDialChild(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage())).then((value) => loadData()),
          label: 'Edit price',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.delete, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DeletePage()))
              .then((value) => loadData()),
          label: 'Delete Product',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.red,
        ),
      ],
    );
  }
}
