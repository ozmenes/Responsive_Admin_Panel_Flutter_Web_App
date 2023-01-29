import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/screens/main/header.dart';
import 'package:responsive_admin_panel_web_app/screens/profile/edit_profile.dart';
import 'package:responsive_admin_panel_web_app/screens/profile/profile_view.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const DashboardHeader(
              title: "Profile",
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ProfileUserData(),
                        if (Responsive.isMobile(context))
                          const SizedBox(
                            height: defaultPadding,
                          ),
                        if (Responsive.isMobile(context))
                          const ProfileView(),
                      ],
                    )),
                if (!Responsive.isMobile(context))
                  const SizedBox(
                    width: defaultPadding,
                  ),
                // if screen is less than 850
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        if (!Responsive.isMobile(context))
                          const ProfileView(),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
