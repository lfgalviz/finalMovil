import 'package:flutter_firebase/models/products_info.dart';

class Calculo {
  List<ProductsInfo> misProductos;

  //Calculo mostrar los productos
  List<ProductsInfo> mostrarProductos(List<ProductsInfo> products) {
    int cont = 0;
    for (var i = 0; i < products.length; i++) {
      if (products[i].number > 0) {
        cont++;
      }
    }
    misProductos = new List(cont);
    cont = 0;
    for (var i = 0; i < products.length; i++) {
      if (products[i].number > 0) {
        misProductos[cont] = products[i];
        cont++;
      }
    }
    return misProductos;
  }

  //CALCULO EL TOTAL DEL PRECIO DE TODOS LOS PRODUCTOS
  double totalMisProductos(List<ProductsInfo> products) {
    double total = 0;
    for (var i = 0; i < products.length; i++) {
      total += products[i].number.toDouble() * products[i].price;
      print(products[i].number.toDouble());
      print(products[i].price);
    }
    return total;
  }
}
