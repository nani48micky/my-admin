import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/main_screen_provider.dart';
import '../../utility/extensions.dart';
import '../../utility/responsive.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MainScreenProvider>().scaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SideMenu()
          : null, // Drawer for smaller screens
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: Text("Admin Panel"),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  context
                      .read<MainScreenProvider>()
                      .scaffoldKey
                      .currentState
                      ?.openDrawer();
                },
              ),
            )
          : null, // AppBar only for smaller screens
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) // SideMenu for desktop view
              Expanded(
                // default flex = 1
                child: SideMenu(),
              ),
            Expanded(
              // Main content area
              flex: 5,
              child: Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  return provider.selectedScreen;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
