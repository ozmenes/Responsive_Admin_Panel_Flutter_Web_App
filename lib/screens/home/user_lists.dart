import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/screens/home/user_tile.dart';

class UserLists extends StatefulWidget {
  const UserLists({Key? key}) : super(key: key);

  @override
  _UserListsState createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserInformation?>?>(context);
    if(users!=null){
      users.forEach((user) {
        debugPrint(user!.fullName);
        debugPrint(user.email);
      });
    }else{
      debugPrint('users return null..');
    }
    return ListView.builder(
      itemCount: users!.length,
      itemBuilder: (context, index){
        return const UserTile(
           // user: users[index]
        );
      },
    );
  }
}
