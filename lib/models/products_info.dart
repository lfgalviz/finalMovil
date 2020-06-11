class ProductsInfo {
  final String name;
  final double price;
  final String category;
  int number=0;

  ProductsInfo({this.name, this.price, this.category});

  void onChangeNumber(int valor){
    number=valor;
  }
}

enum Category {
    VERDURA,
    LACTEO,
    CARNE,
    LIMPIEZA,
    DESPENSA,
    FRUTA,
    SALUD
}