import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrewMember {
  final String name;
  final String lastname;
  final String phone;
  final String uid;
  final String url;
  final String total;
  bool agregarLista = false; //Agregar a mi lista para comprar su mercado
  Icon icono = new Icon(Icons.add,
      color: Colors.pinkAccent); //Icono de agrregar o quitar lista
  int totalPrecio = 0; //total precio de la lista

  CrewMember({
    this.name,
    this.lastname,
    this.phone,
    this.uid,
    this.url,
    this.total,
  });

  void setTotalPrecio(int precio) {
    totalPrecio = precio;
  }

  void onSelectList(bool valor) {
    agregarLista = valor;
    if (valor == false) {
      icono = new Icon(Icons.add, color: Colors.pinkAccent);
    } else {
      icono = new Icon(Icons.delete, color: Colors.pinkAccent);
    }
    print(agregarLista);
  }
}
