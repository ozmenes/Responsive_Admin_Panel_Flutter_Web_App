import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/screens/dashboad/my_files.dart';
import 'package:responsive_admin_panel_web_app/screens/dashboad/storage_details.dart';
import 'package:responsive_admin_panel_web_app/screens/main/header.dart';
import 'package:responsive_admin_panel_web_app/screens/user/user_page.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/responsive.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const DashboardHeader(title: "Dashboard",),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      //const UploadImageToFireStorage(),
                      const MyFiles(),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      // if (Responsive.isDesktop(context))
                      //const UserPanel(),
                      const UserPage(),
                      //const RecentFiles(),
                      if (Responsive.isMobile(context))
                        const SizedBox(
                          height: defaultPadding,
                        ),
                      // if screen is less than 850
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(
                    width: defaultPadding,
                  ),
                // if screen is less than 850
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const StorageDetails(),
                        if (Responsive.isDesktop(context))
                          const SizedBox(
                            height: defaultPadding,
                          ),
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