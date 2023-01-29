import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformationPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {


        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['fullName']),
              subtitle: Text(data['uid']),
            );
          }).toList(),
        );
      },
    );
  }
}

class CurrentUserInfo extends StatefulWidget {
  const CurrentUserInfo({Key? key,this.info}) : super(key: key);
  final UserInformation? info;

  @override
  _CurrentUserInfoState createState() => _CurrentUserInfoState();
}

class _CurrentUserInfoState extends State<CurrentUserInfo> {
  final userRole = ['Admin', "Manager", "User"];
  final _formKey = GlobalKey<FormState>();
  // text field state
  String? address = '';
  String? phone = '';
  String? fullName = '';
  String? role;

  @override
  void initState() {
    role = widget.info?.role;
    fullName = widget.info?.fullName;
    //widget.info != null ? imageUrl : imageUrl;
    address = widget.info?.address;
    phone = widget.info?.phone;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                //controller: _fullName,
                initialValue: fullName,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                validator: (val) =>
                val!.isEmpty ? 'Enter your Full name' : null,
                onChanged: (val) {
                  setState(() {
                    fullName = val;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 250,
              child: TextFormField(
                //controller: _address,
                initialValue: address,
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                validator: (val) =>
                val!.isEmpty ? 'Enter your address' : null,
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 250,
              child: TextFormField(
                //controller: _phone,
                initialValue: phone,
                decoration: InputDecoration(
                  labelText: "Phone number",
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                validator: (val) =>
                val!.isEmpty ? 'Enter your Phone number' : null,
                onChanged: (val) {
                  setState(() {
                    phone = val;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 250,
              child: DropdownButton<String>(
                hint: Text(
                  "Role",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                style: const TextStyle(
                    color: Colors.white, decorationColor: Colors.white),
                isExpanded: true,
                iconSize: 36,
                value: role,
                items: userRole.map(buildMenuItem).toList(),
                onChanged: (val) {
                  setState(() {
                    role = val!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
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
