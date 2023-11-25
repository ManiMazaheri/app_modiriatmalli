import 'package:app_modiriatmali/models/money.dart';
import 'package:app_modiriatmali/screens/home_screen.dart';
import 'package:app_modiriatmali/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>('moneyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void getData() {
    HomeScreen.moneys.clear();
    Box<Money> HiveBox = Hive.box<Money>('moneyBox');
    HiveBox.values.forEach((value) {
      HomeScreen.moneys.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'iransas'),
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیریت مالی',
      home: MainScreen(),
    );
  }
}
