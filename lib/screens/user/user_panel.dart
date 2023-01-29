import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/loading.dart';

import '../../services/database.dart';

class UserPanel extends StatelessWidget {
  const UserPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: StreamProvider<List<UserInformation>>.value(
        value: DatabaseService().getUsers,
        initialData: const [],
        child: const UserList(),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<List<UserInformation>>(context);
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: user.length,
      itemBuilder: (context, index) {
        return UserTile(info: user[index]);
      },
    );
  }
}

class UserTile extends StatefulWidget {
  const UserTile({Key? key, required this.info}) : super(key: key);
  final UserInformation info;
  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  void _showSettingsPanel(String? information) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
            child: SettingForm(
              userUID: information,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String? role = widget.info.role;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color:
            secondaryColor, //.withOpacity(0),//Colors.transparent.withOpacity(0.1),
        child: ListTile(
          leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.white,
              child: Text(
                role!.substring(0, 1),
                style: const TextStyle(
                    color: secondaryColor, fontWeight: FontWeight.bold),
              )),
          title: Text(widget.info.fullName.toString()),
          subtitle: Text(
            widget.info.email.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          dense: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  try {
                    _showSettingsPanel(widget.info.uid);
                    debugPrint(widget.info.uid.toString());
                  } catch (e) {
                    debugPrint('User could not edit,error is $e');
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.white70),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    _showDialog();
                    await DatabaseService(uid: widget.info.uid)
                        .deleteUser(widget.info.uid.toString());
                    debugPrint(widget.info.uid.toString());
                  } catch (e) {
                    debugPrint(
                        'User could not delete,error is $e');
                  }
                },
                icon: Icon(Icons.delete, color: Colors.redAccent[200]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text(
            "Notice",
            style: TextStyle(color: Colors.red),
          ),
          content: const Text("Do you want to delete this user?"),

          actions: <Widget>[
            TextButton(
              child: const Text("No",style: TextStyle(color: Colors.white),),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Yes",style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class SettingForm extends StatefulWidget {
  const SettingForm({Key? key, this.userUID}) : super(key: key);
  final String? userUID;
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  // form values
  final userRole = ['Admin', "Manager", "User"];
  String? _currentName;
  String? _currentAddress;
  String? _currentPhone;
  String? _currentRole;
  String? _currentEmail;
  late String getUid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserInformation?>(
        stream: DatabaseService(uid: widget.userUID).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInformation? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    const Text(
                      'Update user information',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData?.fullName,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: userData?.email,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter an email' : null,
                      onChanged: (val) => setState(() => _currentEmail = val),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: userData?.address,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter an address' : null,
                      onChanged: (val) => setState(() => _currentAddress = val),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: userData?.phone,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter a phone' : null,
                      onChanged: (val) => setState(() => _currentPhone = val),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 250,
                      child: DropdownButton<String>(
                        style: const TextStyle(
                            color: Colors.white,
                            decorationColor: Colors.white),
                        isExpanded: true,
                        iconSize: 36,
                        value: _currentRole,
                        hint: Text(userData!.role.toString(),style: const TextStyle(color: Colors.white),),
                        items: userRole.map(buildMenuItem).toList(),
                        onChanged: (val) {
                          setState(() {
                            _currentRole = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    MaterialButton(
                        color: Colors.pink[400],
                        child: const Text(
                          'Update user',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //_currentUid = widget.userUID;
                            debugPrint('${widget.userUID} uid');
                            debugPrint('Name$_currentName');
                            String imageUrl = "";
                            await DatabaseService()
                                .updateUserData(
                              widget.userUID!,
                              _currentName ??
                                  snapshot.data!.fullName.toString(),
                              imageUrl,
                              // _auth.currentUser!.metadata.creationTime
                              //     .toString(),
                              DateFormat.yMd().add_Hm().format(DateTime.now()),
                              //_currentEmail ?? snapshot.data!.email.toString(),
                              _currentPhone ?? snapshot.data!.phone.toString(),
                              _currentAddress ??
                                  snapshot.data!.address.toString(),
                              _currentRole ?? snapshot.data!.role.toString(),
                            );
                            Navigator.pop(context);
                          }
                        }),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
      ),
    );
  }
}
