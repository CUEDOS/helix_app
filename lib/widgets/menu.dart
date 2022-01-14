import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
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
            onTap: () => {Navigator.pushNamed(context, '/control')},
          ),
          ListTile(
            leading: const Icon(Icons.airplanemode_active),
            title: const Text('Swarm Setup'),
            onTap: () => {Navigator.pushNamed(context, '/swarm_setup')},
          ),
          ListTile(
            leading: const Icon(Icons.computer),
            title: const Text('SITL Setup'),
            onTap: () => {Navigator.pushNamed(context, '/sitl_setup')},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.pushNamed(context, '/feedback')},
          ),
        ],
      )),
      Align(
        alignment: FractionalOffset.bottomCenter,
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () => {Navigator.pushNamed(context, '/settings')},
        ),
      ),
    ]);
  }
}
