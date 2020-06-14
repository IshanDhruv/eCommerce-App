import 'dart:convert';
import 'package:ecommerceapp/models/product.dart';
import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String id;

  ProductPage({this.id});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductService _service = ProductService();
  Product _product;
  bool _isLoading = false;

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await _service.getProduct(widget.id);
    if (result != null) {
      setState(() {
        _product = Product.fromJsonList(jsonDecode(result));
      });
      return true;
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    loadData().then((value) {
      print(_product.name);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _color;
    if (_product.color == "blue")
      _color = Colors.blue;
    else if (_product.color == "white")
      _color = Colors.white;
    else if (_product.color == "black") _color = Colors.black;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_product.brand, style: TextStyle(fontSize: 30)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_product.gender, style: TextStyle(color: _color)),
                              Text(_product.price.toString(), style: TextStyle(fontSize: 20, color: Colors.green))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  MaterialButton(
                    minWidth: 500,
                    color: Colors.green,
                    child: Text("Add to Cart"),
                    onPressed: () async {
                      //add to cart
                    },
                  )
                ],
              ),
            ),
    );
  }
}
