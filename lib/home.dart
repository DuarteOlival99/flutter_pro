import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'item-add.dart';
import 'models/product.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List list = getProducts();

  int _qtdAdquiridosTotal() {
    int qtd = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].color == Colors.grey) {
        qtd += list[i].quantity;
      }
    }
    return qtd;
  }

  double _precoAdquiridosTotal() {
    double precoTotal = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].color == Colors.grey) {
        precoTotal += list[i].price * list[i].quantity;
      }
    }
    return precoTotal;
  }

  int _qtdTotal() {
    int qtd = 0;
    for (int i = 0; i < list.length; i++) {
      qtd += list[i].quantity;
    }
    return qtd;
  }

  double _precoTotal() {
    double precoTotal = 0;
    for (int i = 0; i < list.length; i++) {
      precoTotal += list[i].price * list[i].quantity;
    }
    return precoTotal;
  }

  @override
  Widget build(BuildContext context) {
    List aux = ModalRoute.of(context).settings.arguments;
    if (aux != null) {
      list = aux;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Lista de Produtos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              // Abre tela para criar item de lista
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemAddPage(),
                      settings: RouteSettings(
                        arguments: list,
                      )));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          height: 590,
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCard(context, index)),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              // color: Layout.secondary()
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ]),
            ),
            child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(
                            'Adquiridos: ',
                          ),
                          Text(
                            _qtdAdquiridosTotal().toString(),
                          ),
                        ]),
                        Column(children: <Widget>[
                          Text(
                            'Preço total: ',
                          ),
                          Text(
                            _precoAdquiridosTotal().toString() + '€',
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            left: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(
                            'Nao adquiridos: ',
                          ),
                          Text(
                            (_qtdTotal() - _qtdAdquiridosTotal()).toString(),
                          ),
                        ]),
                        Column(children: <Widget>[
                          Text(
                            'Preço total: ',
                          ),
                          Text(
                            (_precoTotal() - _precoAdquiridosTotal())
                                    .toString() +
                                '€',
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(
                            'Total de itens: ',
                          ),
                          Text(
                            _qtdTotal().toString(),
                          ),
                        ]),
                        Column(children: <Widget>[
                          Text(
                            'Preço total: ',
                          ),
                          Text(
                            _precoTotal().toString() + '€',
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }

  Widget buildTripCard(BuildContext context, int index) {
    final product = list[index];

    void _removeProduct() {
      setState(() {
        list.remove(product);
      });
    }

    void _aumentaQuantity() {
      setState(() {
        product.quantity++;
      });
    }

    void _diminuiQuantity() {
      setState(() {
        if (!(product.quantity <= 0)) {
          product.quantity--;
        }
      });
    }

    void _alteraCor() {
      if (product.color == Colors.grey) {
        setState(() {
          product.color = Colors.blue[50];
        });
      } else {
        setState(() {
          product.color = Colors.grey;
        });
      }
    }

    Widget _decideImageView() {
      if (product.imageFile == null) {
        return Container(
          height: 100.0,
          width: 70.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(product.image))),
        );
      } else {
        Future<File> image = product.imageFile;
        return FutureBuilder<File>(
            future: image,
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              return Image.file(
                snapshot.data,
                width: 300,
                height: 300,
              );
            });
      }
    }

    return new Container(
        child: Dismissible(
      key: Key(product.name),
      background: slideRightBackground(product),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content:
                      Text("Are you sure you want to delete ${product.name}?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        // TODO: Delete the item from DB etc..
                        _removeProduct();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          return res;
        } else {
          // TODO: Navigate to edit page;
          _alteraCor();
        }
      },
      child: Card(
        elevation: 5,
        color: product.color,
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                height: 100.0,
                width: 70.0,
                child: _decideImageView(),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                          mainAxisSize: MainAxisSize
                              .min, // this will take space as minimum as posible(to center)
                          children: <Widget>[
                            Text(
                              product.name,
                              style: new TextStyle(fontSize: 30),
                            ),
                          ]),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Container(
                          width: 170,
                          child: Text(
                            "Preco por unidade: " +
                                product.price.toString() +
                                "€",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ButtonBar(
                        mainAxisSize: MainAxisSize
                            .min, // this will take space as minimum as posible(to center)
                        children: <Widget>[
                          new Container(
                            width: 85,
                            child: Text(
                              "Quantidade:",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 48, 48, 54)),
                            ),
                          ),
                          new SizedBox(
                            width: 50,
                            child: RawMaterialButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.remove),
                                ],
                              ),
                              onPressed: _diminuiQuantity,
                            ),
                          ),
                          new Container(
                            width: 20,
                            child: Center(
                              child: Text(
                                product.quantity.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 48, 48, 54)),
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 50,
                            child: RawMaterialButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.add),
                                ],
                              ),
                              onPressed: _aumentaQuantity,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                        child: Container(
                          width: 260,
                          child: Text(
                            "Preço total: " +
                                (product.price * product.quantity).toString() +
                                "€",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget slideRightBackground(Product product) {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              (() {
                if (product.color == Colors.grey) {
                  return "Nao Adquirido";
                }
                return "Adquirir";
              })(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
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
