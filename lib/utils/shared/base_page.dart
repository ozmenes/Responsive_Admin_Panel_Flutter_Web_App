import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/progress_hud.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: buildPageUI(),
      ),
    );
  }

  pageUI() {
    return null;
  }

  buildPageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.light,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.notifications_none, size: 32, color: Colors.black),
        ),
        const SizedBox(
          width: 10,
        ),
        Stack(
          children: const [
            Center(
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.shopping_cart_outlined,
                    size: 32, color: Colors.black),
              ),
            ),
            Positioned(
              top: 3,
              right: 4,
              child: Icon(
                Icons.brightness_1,
                size: 21.0,
                color: Colors.redAccent,
              ),
            ),
            Positioned(
              top: 6,
              right: 9,
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
