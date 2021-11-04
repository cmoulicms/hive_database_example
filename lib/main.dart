import 'package:flutter/material.dart';
import 'package:flutter_enercent/theme.dart';
import 'constants.dart';
import 'page/home_page.dart';
import 'model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Flutter Demo',
      theme: theme(),
      home: FutureBuilder(
        future: Hive.openBox<User>(usersBox),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const HomePage();
            }
          } else {
            return const Scaffold();
          }
        }
      )
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
