import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 72,
            child: DrawerHeader(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Image.asset(
                      'images/flutibre-icon.png',
                      height: 72,
                    ),
                    const Text(
                      'Flutibre',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
