import 'package:ecommerceapp/models/product.dart';
import 'package:ecommerceapp/models/user.dart';
import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  User user;

  CartPage({this.user});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;
  bool _isEmpty = false;
  ProductService _service = ProductService();
  Map _cartData;
  Product _product;
  int _totalValue;

  Future loadCartItems() async {
    _cartData = await _service.getCart(widget.user.authToken);
    if (_cartData["prod"].length == 0) {
      setState(() {
        _isEmpty = true;
      });
    }
    else{
      _totalValue = _cartData["cartValue"];
    }
      setState(() {
        _isLoading = false;
      });

  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    loadCartItems().then((value) {
     // _totalValue = _cartData["cartValue"];
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart"), actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            child: Tooltip(child: Icon(Icons.remove_shopping_cart), message: "Clear Cart"),
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              _service.clearCart(widget.user.authToken).then((value) {
                setState(() {
                  _cartData["prod"].clear();
                  _cartData["cartValue"] = 0;
                  _isLoading = false;
                  Navigator.pop(context);
                });
              });
            },
          ),
        ),
      ]),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isEmpty
              ? Center(child: Text("No items in cart", style: TextStyle(fontSize: 30)))
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var _color;
                            _product = Product.fromJsonList(_cartData["prod"][index]);
                            if (_product.color == "blue")
                              _color = Colors.blue;
                            else if (_product.color == "white")
                              _color = Colors.white;
                            else if (_product.color == "black") _color = Colors.black;
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
                                          Text(_product.brand, style: TextStyle(fontSize: 30)),
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
                                            icon: Icon(Icons.remove),
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              await _service.deleteFromCart(_product.id, widget.user.authToken).then((value) => loadCartItems());
                                            },
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(_product.gender),
                                          Text('\$' + _product.price.toString(),
                                              style: TextStyle(fontSize: 20, color: Colors.green))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: _cartData["prod"].length,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Total value",
                              style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)),
                          Text(_totalValue.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
