import 'package:ecommerceapp/services/database.dart';
import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  bool _isLoading = false;
  String productCode = '';
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
                      RaisedButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await _service.deleteProduct(productCode).then((value) {
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
