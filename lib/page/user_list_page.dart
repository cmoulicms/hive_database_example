import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../model/user.dart';
import 'user_info_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Users List')),
        body: _buildUserListView());
  }

  // list users in the users database
  // using ValueListenableBuilder to listen to any changes that happen in the user's database
  Widget _buildUserListView() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<User>(usersBox).listenable(),
        builder: (context, Box<User> _usersBox, _) {
          // check if users database is empty or not
          if (_usersBox.values.isEmpty) {
            return const Center(child: Text('No users'));
          }
          return ListView.builder(
              itemCount: _usersBox.values.length,
              itemBuilder: (context, index) {
                final indexValue = index;
                final user = _usersBox.getAt(index) as User;
                return Padding(
                  padding: defaultPadding,
                  child: Card(
                    child: ListTile(
                      title: Text('Name : ${user.name}'),
                      subtitle: Text('Age : ${user.age.toString()}'),
                      trailing:
                          Text('\u{20B9} ${user.balanceAmount.toString()}'),
                      // tap listtile to show user infomation
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                                    UserInfoPage(userInfo: indexValue)));
                      },
                      // longPress to remove user in users database
                      onLongPress: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  Text('Do you want to delete ${user.name}?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      await _usersBox.deleteAt(index);
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              });
        });
  }
}
