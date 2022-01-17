import 'package:flutter/material.dart';

import 'package:helixio_app/pages/control.dart';
import 'package:helixio_app/pages/swarm_setup.dart';
import 'package:helixio_app/pages/sitl_setup.dart';
import 'package:helixio_app/pages/feedback.dart';
import 'package:helixio_app/pages/settings.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  StatelessWidget? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.control_camera_rounded),
            title: const Text('Control'),
            onTap: () => setState(() {
              selectedItem = const ControlScreen();
            }),
          ),
          ListTile(
            leading: const Icon(Icons.airplanemode_active),
            title: const Text('Swarm Setup'),
            onTap: () => setState(() {
              selectedItem = const SwarmSetupScreen();
            }),
          ),
          ListTile(
            leading: const Icon(Icons.computer),
            title: const Text('SITL Setup'),
            onTap: () => setState(() {
              selectedItem = const SITLSetupScreen();
            }),
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => setState(() {
              selectedItem = const FeedbackScreen();
            }),
          ),
        ],
      )),
      Align(
        alignment: FractionalOffset.bottomCenter,
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () => setState(() {
            selectedItem = const SettingsScreen();
          }),
        ),
      ),
    ]);
  }
}
