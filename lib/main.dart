import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'package:helixio_app/pages/app_menu.dart';
import 'package:helixio_app/pages/split_view.dart';
import 'modules/core/managers/mqtt_manager.dart';
import 'modules/core/managers/swarm_manager.dart';
import 'modules/helpers/service_locator.dart';

void main() {
  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

// 1. extend from ConsumerWidget
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(
              create: (context) => serviceLocator<MQTTManager>()),
          provider.ChangeNotifierProvider(
              create: (context) => serviceLocator<SwarmManager>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplitView(
            menu: const AppMenu(),
            content: selectedPageBuilder(context),
          ),
        ));
  }
}
