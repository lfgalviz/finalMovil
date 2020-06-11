import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/products_info.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {

  List<ProductsInfo> convertToProduct(List data) {
    List<ProductsInfo> array = [];
    for (var i in data) {
      array.add(ProductsInfo(
        category: i["category"],
        name: i['name'],
        price: i['price'],
      ));
    }
    return array;
  }

  Future<List<ProductsInfo>> getAll() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://frutiland.herokuapp.com/search"),
        headers: {"Accept": "application/json"});

    List<ProductsInfo> productInfoArray =
        convertToProduct(json.decode(response.body));

    productInfoArray.forEach((elem)=>{print(elem.name)});
    return productInfoArray;
  }

  Future<List<ProductsInfo>> search({category, term}) async {
    if(category == null && term == null) return await getAll();
    print('esto noj se ejecuta, si esta en pantalla, lalme a servicio tecnico');
    if(term == null) term = '';
    if(category == null) category = '';

    http.Response response = await http.get(
        Uri.encodeFull(
            "https://frutiland.herokuapp.com/search?category=$category&q=$term"),
        headers: {"Accept": "application/json"});

    List<ProductsInfo> productInfoArray = convertToProduct(json.decode(response.body));
    productInfoArray.forEach((elem)=>{print(elem.name)});
    return productInfoArray;
  }
}
