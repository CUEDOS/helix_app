import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:helixio_app/pages/control_page.dart';
import 'package:helixio_app/pages/swarm_setup_page.dart';
import 'package:helixio_app/pages/sitl_setup_page.dart';
import 'package:helixio_app/pages/mqtt_console_page.dart';
import 'package:helixio_app/pages/mqtt_settings_page.dart';

// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'Control': (_) => const ControlPage(),
  'Swarm Setup': (_) => const SwarmSetupPage(),
  'MQTT Console': (_) => const MQTTConsolePage(),
  'MQTT Settings': (_) => const SettingsScreen(),
};

void _checkPlatform() {
  // Adding SITL Setup to the menu only on linux
  if (defaultTargetPlatform == TargetPlatform.linux) {
    _availablePages['SITL Setup'] = (_) => const SITLSetupPage();
  }
}

// make this a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  _checkPlatform();
  return _availablePages.keys.first;
});

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});

// 1. extend from ConsumerWidget
class AppMenu extends ConsumerWidget {
  const AppMenu({Key? key}) : super(key: key);

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedPageNameProvider.state).state != pageName) {
      ref.read(selectedPageNameProvider.state).state = pageName;
      // dismiss the drawer of the ancestor Scaffold if we have one
      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. watch the provider's state
    final selectedPageName = ref.watch(selectedPageNameProvider.state).state;
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: <Widget>[
          for (var pageName in _availablePages.keys)
            PageListTile(
              // 3. pass the selectedPageName as an argument
              selectedPageName: selectedPageName,
              pageName: pageName,
              onPressed: () => _selectPage(context, ref, pageName),
            ),
        ],
      ),
    );
  }
}

class PageListTile extends StatelessWidget {
  const PageListTile({
    Key? key,
    this.selectedPageName,
    required this.pageName,
    this.onPressed,
  }) : super(key: key);
  final String? selectedPageName;
  final String pageName;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // show a check icon if the page is currently selected
      // note: we use Opacity to ensure that all tiles have a leading widget
      // and all the titles are left-aligned
      leading: Opacity(
        opacity: selectedPageName == pageName ? 1.0 : 0.0,
        child: const Icon(Icons.check),
      ),
      title: Text(pageName),
      onTap: onPressed,
    );
  }
}
