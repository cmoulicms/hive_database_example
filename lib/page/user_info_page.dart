import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../model/user.dart';

class UserInfoPage extends StatefulWidget {
  final int userInfo;
  const UserInfoPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final  _addFormKey = GlobalKey<FormState>();
  final  _withdrawFormKey = GlobalKey<FormState>();
  final addController = TextEditingController();
  final withdrawController = TextEditingController();
  late Box _usersBox;
  late int userIndex;

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>(usersBox);
    userIndex = widget.userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Infomation'),
        ),
        body: Padding(
          padding: defaultPadding,
          child: ValueListenableBuilder(
              valueListenable: Hive.box<User>(usersBox).listenable(),
              builder: (context, Box<User> _usersBox, _) {
                final user = _usersBox.getAt(userIndex) as User;
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Name :'),
                      trailing: Text(user.name),
                    ),
                    ListTile(
                      title: const Text('Age :'),
                      trailing: Text(user.age.toString()),
                    ),
                    ListTile(
                      title: const Text('Balance :'),
                      trailing: Text(user.balanceAmount.toString()),
                    ),
                    Column(children: [
                      ElevatedButton(
                          onPressed: () {
                            addAmount(user, userIndex);
                          },
                          child: const Text('Add Amount')),
                      defaultSpace,
                      ElevatedButton(
                          onPressed: () {
                            withdrawAmount(user, userIndex);
                          },
                          child: const Text('Withdraw Amount'))
                    ])
                  ],
                );
              }),
        ));
  }

  // add amount to user database
  Future<void> addAmount(user, indexValue) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Amount'),
          content: SingleChildScrollView(
            child: Form(
              key: _addFormKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some amount';
                  }
                  return null;
                },
                controller: addController,
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_addFormKey.currentState!.validate()) {
                  var _balanceAmount = int.parse(addController.value.text);
                  // add amount to user 
                  _usersBox.putAt(
                      indexValue,
                      User(user.name, user.age,
                          user.balanceAmount + _balanceAmount));
                  Navigator.of(context).pop();
                }
                _addFormKey.currentState!.reset();
              },
            ),
          ],
        );
      },
    );
  }

  // withdraw amount from user database
  Future<void> withdrawAmount(user, indexValue) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Withdraw Amount'),
          content: SingleChildScrollView(
            child: Form(
              key: _withdrawFormKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some amount';
                  }
                  return null;
                },
                controller: withdrawController,
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                ),
                keyboardType: TextInputType.number),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Withdraw'),
              onPressed: () {
                if (_withdrawFormKey.currentState!.validate()) {
                  var _balanceAmount = user.balanceAmount -
                      int.parse(withdrawController.value.text);
                  // The balance amount should not be less than zero
                  if (_balanceAmount < 0) {
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text('you cant withdraw below zero'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } 
                  // Withdraw balance amount
                  else {
                    _usersBox.putAt(
                        indexValue, User(user.name, user.age, _balanceAmount));
                    Navigator.of(context).pop();
                  }
                }
                // reset form current state 
                _withdrawFormKey.currentState!.reset();
              },
            ),
          ],
        );
      },
    );
  }
}
