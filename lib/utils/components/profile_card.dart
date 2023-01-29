import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({Key? key,this.userData}) : super(key: key);
  final UserInformation? userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
       padding: const EdgeInsets.symmetric(
           vertical: defaultPadding / 2, horizontal: defaultPadding),
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: userData!.imageUrl == 'avatar' ? Image.asset(
              'assets/images/ninja.png',
              height: 75,
            ):Image.network(userData!.imageUrl.toString(),
              height: 45,
              fit: BoxFit.cover,),
          ),
          const SizedBox(
            width: 5,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(userData!.fullName.toString(),
              style: Theme.of(context).textTheme.subtitle1,),
            ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
