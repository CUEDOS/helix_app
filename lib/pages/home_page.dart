import 'package:flutter/material.dart';
import 'package:adaptive_layout/adaptive_layout.dart';

import 'package:helixio_app/widgets/menu.dart';
import 'package:helixio_app/pages/control.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helix.io'),
      ),
      // Now using an `AdaptiveLayout` as the `body`
      body: AdaptiveLayout(
        // Provide `MovieListView` as the `smallLayout`
        smallLayout: const MainMenu(),
        // Provide a `Row` as the `largeLayout`
        largeLayout: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Expanded(flex: 1, child: MainMenu()),
            const Expanded(
              flex: 3,
              child: Center(child: Controls()),
            )
          ],
        ),
      ),
    );
  }
}

// Text(
//                   "Select a menu item on the left to see the page here.",
//                 ),

//return const Scaffold(body: MainMenu());