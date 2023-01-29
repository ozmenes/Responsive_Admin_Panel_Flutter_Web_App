import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_admin_panel_web_app/screens/authenticate/authenticate.dart';
import 'package:responsive_admin_panel_web_app/screens/main/main_screen.dart';
import 'package:responsive_admin_panel_web_app/services/auth.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/launcher.png"),
          ),
          const Divider(
            height: 12.0,
            color: Colors.white54,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            onClick: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainScreen(
                      selectedPage: 0,
                    ))),
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            onClick: () {},
          ),
          DrawerListTile(
            title: "Task",
            svgSrc: "assets/icons/menu_task.svg",
            onClick: () {},
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            onClick: () {},
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            onClick: () {},
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            onClick: () {},
          ),
          const Divider(
            height: 12.0,
            color: Colors.white54,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainScreen(
                          selectedPage: 1,
                          )));
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            onClick: () {},
          ),
          const Divider(
            height: 12.0,
            color: Colors.white54,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),
          DrawerListTile(
            title: "Log out",
            color: const Color(0xFFFF5252),
            svgSrc: "assets/icons/menu_setting.svg",
            onClick: () async {
              await _authService.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const Authenticate()));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      this.color = Colors.white54,
      required this.title,
      required this.svgSrc,
      required this.onClick})
      : super(key: key);
  final String title, svgSrc;
  final VoidCallback onClick;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: color,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
