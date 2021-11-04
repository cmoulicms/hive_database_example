import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../model/user.dart';
import 'user_list_page.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({Key? key}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  late Box _usersBox;
  int initialAmount = 500;
  late int age;

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>(usersBox);
  }

  // add new user to users database
  void addUser(User user) {
    _usersBox.add(user);
  }

  // submit user info to users database
  void onFormSubmit() {
    if (_formKey.currentState!.validate()) {
      final newUser = User(nameController.value.text,
          int.parse(ageController.value.text), initialAmount);
      age = int.parse(ageController.value.text);
      // check user age must be greater than or equal to 18
      if (age >= 18) {
        addUser(newUser);
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserListPage()),
      ).then((_) => _formKey.currentState!.reset());
      } else {
        final snackBar = SnackBar(
            content: const Text('user age must be greater than or equal to 18'),
          );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User Form')),
        body: Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                      ),
                    ),
                    defaultSpace,
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                      controller: ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter your age',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              defaultSpace,
              ElevatedButton(
                  onPressed: onFormSubmit, child: const Text('Add New User'))
            ],
          ),
        ));
  }
}
