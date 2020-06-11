import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/crew.dart';
import 'package:flutter_firebase/models/products_info.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // Colecction reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future createUserData(String name, String lastname, String phone) async{
    return await userCollection.document(uid).setData({
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'uid': uid,
      'total': '0',
    });
  }

  Future updateUserData(String url) async{
    return await userCollection.document(uid).updateData({
      'url': url,
    });
  }

  Future totalUserList(double total) async{
    return await userCollection.document(uid).updateData({
      'total': total.toString(),
    });
  }

  // Crew List
  List<CrewMember> _crewListSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return CrewMember(
        name: doc.data['name'] ?? '',
        lastname: doc.data['lastname'] ?? '',
        phone: doc.data['phone'] ?? '',
        uid: doc.data['uid'] ?? '',
        url: doc.data['url'] ?? '',
        total: doc.data['total'] ?? '',
      );
    }).toList();
  }

  // Product List
  List<ProductsInfo> _miListaSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ProductsInfo(
        name: doc.data['name'] ?? '',
        category: doc.data['category'] ?? '',
        price: doc.data['price'] ?? '',
      ).onChangeNumber(doc.data['cant']);
    }).toList();
  }

  // Agrega un solo producto a la lista del usuario
  Future addProducts(String name, double price, String category, int number) async {
    return await userCollection.document(uid).collection('MiLista').document(name).setData({
      'name': name,
      'category': category,
      'price': price,
      'cant': number,
    });
  }

  // Borra productos de la lista del usuario
  Future deleteListProduct(String name) async {
    return await userCollection.document(uid).collection('MiLista').document(name).delete();
  }

  Stream<List<ProductsInfo>> get miLista {
    return userCollection.document(uid).collection('MiLista').snapshots().map(_miListaSnapshot);
  }

  // gets Users's stream
  Stream<List<CrewMember>> get crew {
    return userCollection.snapshots().map(_crewListSnapshot);
  }

}