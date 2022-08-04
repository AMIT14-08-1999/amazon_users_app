import 'package:amazon/assistantMethods/address_changer.dart';
import 'package:amazon/assistantMethods/cart_item_counter.dart';
import 'package:amazon/assistantMethods/total_amount.dart';
import 'package:amazon/global/global.dart';
import 'package:amazon/splashScreen/my_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Users App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home: MySplashScreen(),
      ),
    );
  }
}
