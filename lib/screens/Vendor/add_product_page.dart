import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final String authToken;

  AddProductPage({this.authToken});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool _isLoading = false;
  String _name = '';
  String _brand = '';
  double _price;
  String _gender;
  String _colour;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  ProductService _service = ProductService();

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: Text("Add your product")),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder()),
                          validator: (val) => val.isEmpty ? 'Enter product name' : null,
                          onChanged: (val) {
                            setState(() {
                              _name = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Brand", border: OutlineInputBorder()),
                          validator: (val) => val.isEmpty ? 'Enter product brand' : null,
                          onChanged: (val) {
                            _brand = val;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Price", border: OutlineInputBorder()),
                          validator: (val) => val.isEmpty ? 'Enter product price' : null,
                          onChanged: (val) {
                            _price = double.parse(val);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
                          validator: (val) => val.isEmpty ? 'Enter gender for product consumer' : null,
                          onChanged: (val) {
                            _gender = val;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Colour", border: OutlineInputBorder()),
                          validator: (val) => val.isEmpty ? 'Enter a valid' : null,
                          onChanged: (val) {
                            _colour = val;
                          },
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                            child: Text(
                              "Add product",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _service.addProduct(
                                    widget.authToken, _name, _brand, _price, _gender, _colour.toLowerCase()).then((result) {
                                  print(result);
                                  if (result != true)
                                    setState(() {
                                      error = 'Could not add';
                                      _isLoading = false;
                                    });
                                  else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  }
                                });

                              }
                            }),
                        SizedBox(height: 20),
                        Text(error),
                      ],
                    ),
                  )),
            ),
          );
  }
}
