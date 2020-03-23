import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'models/ProductEdit.dart';

class ProductEditPage extends StatefulWidget {
  static String tag = 'page-item-edit';

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cDescription = TextEditingController();
  final TextEditingController _cValor = TextEditingController();
  final TextEditingController _cQtd = TextEditingController();
  File imageFile;
  Future<File> image;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ProductEdit args = ModalRoute.of(context).settings.arguments;
    List listProduct = args.list;
    int index = args.index;
    _cName.text = listProduct[index].name;
    _cDescription.text = listProduct[index].description;
    _cValor.text = listProduct[index].price.toString();
    _cQtd.text = listProduct[index].quantity.toString();

    final inputName = TextFormField(
      controller: _cName,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Nome do item',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return "";
      },
    );

    final inputDescription = TextFormField(
      controller: _cDescription,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Descricao do item',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return "";
      },
    );

    final inputQuantidade = TextFormField(
      controller: _cQtd,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Quantidade',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return "";
      },
    );

    final inputValor = TextFormField(
      controller: _cValor,
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          hintText: 'Valor €',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return "";
      },
    );

    void adicionaLista(
        String name, String descricao, int quantidade, double preco) {
      if (image != null) {
        listProduct[index].imageFile = image;
      }

      listProduct[index].name = name;
      listProduct[index].description = descricao;
      listProduct[index].quantity = quantidade;
      listProduct[index].price = preco;
    }

    //Open gallery
    pickImageFromGallery(ImageSource source) {
      setState(() {
        image = ImagePicker.pickImage(source: source);
      });
    }

    Widget showImage() {
      return FutureBuilder<File>(
        future: image,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(
              snapshot.data,
              width: 300,
              height: 300,
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error na Imagem',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              '',
              textAlign: TextAlign.center,
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Adicionar Produto"),
      ),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                showImage(),
                RaisedButton(
                  child: Text("Altera a imagem"),
                  onPressed: () {
                    pickImageFromGallery(ImageSource.gallery);
                  },
                ),
                SizedBox(height: 10),
                Text('Nome do produto'),
                inputName,
                SizedBox(height: 10),
                Text('descrição do produto'),
                inputDescription,
                SizedBox(height: 10),
                Text('Quantidade'),
                inputQuantidade,
                Text('Preço por unidade'),
                inputValor,
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.black12,
                      child: Text('Cancelar',
                          style: TextStyle(color: Colors.white)),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      child:
                          Text('Editar', style: TextStyle(color: Colors.white)),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPressed: () {
                        adicionaLista(_cName.text, _cDescription.text,
                            int.parse(_cQtd.text), double.parse(_cValor.text));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(),
                              settings: RouteSettings(
                                arguments: listProduct,
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
