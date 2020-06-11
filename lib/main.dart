import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/products.dart';
import 'package:flutter_firebase/models/products_info.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/screens/Tabs/tab1.dart';
import 'package:flutter_firebase/screens/Tabs/tab2.dart';
import 'package:flutter_firebase/screens/Tabs/tab3.dart';
import 'package:flutter_firebase/screens/wrapper.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:provider/provider.dart';

import 'models/crew.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        FutureProvider<List<ProductsInfo>>(
          create: (_) => Products().search(),
        ),
        StreamProvider<List<CrewMember>>.value(value: DatabaseService().crew),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/segunda': (context) => ShoppingList(),
          '/tercera': (context) => FriendsShoppingList(),
          '/cuarta': (context) => CompleteShoppingList(),
        },
      ),
    );
  }
}
