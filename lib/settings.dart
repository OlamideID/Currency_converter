import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.selectScreen});
  final Function(String) selectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 50,
          // ),

          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.blue.shade800,
                Colors.blue,
              ], end: Alignment.bottomRight, begin: Alignment.topLeft)),
              child: Row(
                children: [
                  Container(
                    child: Image.asset(
                        'lib/assets/currency-exchange-money-conversion-euro-600nw-1919947535.webp'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Options',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          ListTile(
            onTap: () {
              selectScreen('Home');
            },
            leading: const Icon(
              Icons.home,
              size: 26,
              color: Colors.black,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 25),
            ),
          ),
          ListTile(
            onTap: () {
              selectScreen('Settings');
            },
            leading: const Icon(
              Icons.sort,
              size: 26,
              color: Colors.black,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
