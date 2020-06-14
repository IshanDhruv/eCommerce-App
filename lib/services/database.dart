import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class ProductService {
  Future getProduct(String id) async {
    var headers = {'Content-type': 'application/json'};
    print(id);
    try {
      final response = await http.get(
        "https://kicksup.herokuapp.com/products/" + '$id',
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future addToCart(String productID, String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization': authToken};
    var body = jsonEncode({'productid': productID});
    try {
      final response = await http.post("https://kicksup.herokuapp.com/users/addtocart", headers: headers, body: body);
      if (response.statusCode == 201) {
        return response.body;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getCart(String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization': authToken};
    try {
      final response = await http.get(
        "https://kicksup.herokuapp.com/users/mycart",
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteFromCart(String productID, String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization': authToken};
    var body = jsonEncode({'productid': productID});
    try {
      final response =
          await http.post("https://kicksup.herokuapp.com/users/deletefromcart", headers: headers, body: body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future clearCart(String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization': authToken};
    try {
      final response = await http.get(
        "https://kicksup.herokuapp.com/users/clearcart",
        headers: headers,
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getLatestID(String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization': authToken};
    try {
      final response = await http.get(
        "https://kicksup.herokuapp.com/products",
        headers: headers,
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        List<int> ids = List();
        var maxID;
        for (var i = 0; i < data.length; i++) {
          ids.add(int.parse(data[i]["id"]));
        }
        maxID = ids.reduce(max);
        return maxID;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future addProduct(String authToken, String name, String brand, double price, String gender, String colour) async {
    String id;
    await getLatestID(authToken).then((value) {
      id = (value + 1).toString();
    }).then((value) async {
      print(id);
      var headers = {'Content-type': 'application/json', 'Authorization': authToken, 'Dev_Auth': 'GGMUheroku'};
      var body =
          jsonEncode({'name': name, 'brand': brand, 'id': id, 'price': price, 'gender': gender, 'colour': colour});
      try {
        final response = await http.post("https://kicksup.herokuapp.com/products/create", headers: headers, body: body);
        if (response.statusCode == 201) {
          print('added');
          return true;
        } else {
          print(response.statusCode);
          print(response.body);
          return null;
        }
      } catch (e) {
        print(e);
        return null;
      }
    });
  }

  Future deleteProduct(String productCode) async {
    var headers = {'Content-type': 'application/json', 'Dev_Auth': 'GGMUheroku'};
    try {
      final response = await http.delete("https://kicksup.herokuapp.com/products/" + '$productCode', headers: headers);
      if (response.statusCode == 200) {
        print('deleted');
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future editProduct(String productCode, double price) async {
    var headers = {'Content-type': 'application/json', 'Dev_Auth': 'GGMUheroku'};
    var body = jsonEncode({'price': price});
    try {
      final response = await http.patch("https://kicksup.herokuapp.com/products/" + '$productCode' + '/update',
          headers: headers, body: body);
      if (response.statusCode == 200) {
        print('updated');
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
