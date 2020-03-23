import 'package:flutter/material.dart';
import 'package:flutterpro/product-edit.dart';

import 'home.dart';
import 'item-add.dart';
import 'models/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    ProductAddPage.tag: (context) => ProductAddPage(),
    ProductEditPage.tag: (context) => ProductEditPage(),
  };

  @override
  Widget build(BuildContext context) {
    List list = getProducts();
    return MaterialApp(
        title: 'ThizerList',
        theme: ThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.white,
            textTheme: TextTheme(
                headline: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                title: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
                body1: TextStyle(fontSize: 14))),
        home: HomePage(),
        routes: routes);
  }

  List getProducts() {
    return [
      Product(
        name: "q0",
        description: "q0",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q1",
        description: "q1",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q2",
        description: "q2",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q3",
        description: "q3",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q4",
        description: "q4",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q5",
        description: "q5",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q6",
        description: "q6",
        price: 20,
        quantity: 2,
      ),
      Product(
        name: "q7",
        description: "q7",
        price: 20,
        quantity: 2,
      ),
    ];
  }
}
