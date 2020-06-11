import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/models/crew.dart';
import 'package:flutter_firebase/models/products_info.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/services/calculos.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<TextEditingController> _text;
  List<ProductsInfo> misProductos;
  Calculo c = new Calculo();

  @override
  void dispose() {
    for (var i = 0; i < _text.length; i++) {
      _text[i].dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    //MULTIPROVIDERS
    final productos = Provider.of<List<ProductsInfo>>(context, listen: true);
    final crews = Provider.of<List<CrewMember>>(context, listen: true);
    final user = Provider.of<User>(context, listen: false);

    //GENERO UNA LISTA CONTROLADORA DE TEXTFIELD
    _text = List.generate(productos.length, (i) => TextEditingController());
    for (var i = 0; i < _text.length; i++) {
      _text[i].text = productos[i].number.toString();
    }

    //SCAFFOLD
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text("My Shopping List"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 80.0),
        child: ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 5.0,
                    margin: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            productos[index].name,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Container(
                              width: 50.0,
                              child: TextField(
                                controller: _text[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()  {
          setState(() {
            //VEO CUALES TEXTFIELD NO ESTAN VACIOS Y LOS GUARDO EN UN ARRAY QUE EN UN FUTURO SERAN MI LISTA
            for (var i = 0; i < _text.length; i++) {
              if (_text[i].text.isNotEmpty) {
                productos[i].onChangeNumber(int.parse(_text[i].text));
              }
            }
            //LLAMO LA  FUNCION PARA GUARDAR LOS PRECIOS PRODUCTOS EN MI LISTA
            misProductos = c.mostrarProductos(productos);
            for (var i = 0; i < crews.length; i++) {
              if (crews[i].uid == user.uid) {
                crews[i].totalPrecio =
                    c.totalMisProductos(misProductos).toInt();
              }
            }
          });

          // Limpia toda la Lista del Usuario en FireStore
          productos.forEach((element) async {
            await DatabaseService(uid: user.uid).deleteListProduct(element.name);
          });

          // Agrega los productos seleccionados a la lista del usuario en FireStore
          misProductos.forEach((element) async {
            DatabaseService(uid: user.uid).addProducts(element.name, element.price, element.category,element.number);
          });

          DatabaseService(uid: user.uid).totalUserList(c.totalMisProductos(misProductos));
          Navigator.pop(context);
          Navigator.pushNamed(context, '/tercera');
        },
        label: Text('Update'),
        icon: Icon(Icons.update),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
