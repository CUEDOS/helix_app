import 'package:flutter/material.dart';

import 'package:helixio_app/pages/home_page.dart';
import 'package:helixio_app/pages/control.dart';
import 'package:helixio_app/pages/swarm_setup.dart';
import 'package:helixio_app/pages/sitl_setup.dart';
import 'package:helixio_app/pages/feedback.dart';
import 'package:helixio_app/pages/settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helixio Desktop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/control': (context) => const ControlScreen(),
        '/swarm_setup': (context) => const SwarmSetupScreen(),
        '/sitl_setup': (context) => const SITLSetupScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
