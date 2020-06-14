import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _isLoading = false;
  String productCode = '';
  String price;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  ProductService _service = ProductService();

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Delete product"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text("This is for vendors only!", style: TextStyle(fontSize: 20, color: Colors.red)),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Product Code", border: OutlineInputBorder()),
                        validator: (val) => val.isEmpty ? 'Enter a product code' : null,
                        onChanged: (val) {
                          setState(() {
                            productCode = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "New price", border: OutlineInputBorder()),
                        validator: (val) => val.isEmpty ? 'Enter a price' : null,
                        onChanged: (val) {
                          setState(() {
                            price = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          child: Text(
                            "Change price",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await _service.editProduct(productCode, double.parse(price)).then((value) {
                                if (value == null)
                                  setState(() {
                                    error = 'Could not delete';
                                    _isLoading = false;
                                  });
                                else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            }
                          }),
                      Text(error),
                    ],
                  ),
                )),
          );
  }
}
