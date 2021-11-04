import 'package:flutter/material.dart';

import '../constants.dart';
import 'user_form_page.dart';
import 'user_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Padding(
          padding: defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: createUser, 
                child: const Text('Create User')
              ),
              defaultSpace,
              ElevatedButton(
                onPressed: listUser, 
                child: const Text('List User')
              )
            ],
          ),
        ),
      )
    );
  }

  // navigate to user form page
  void createUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserFormPage())
    );
  }
  // navigate to user list page
  void listUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserListPage())
    );
  }
}