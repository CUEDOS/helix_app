import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'package:helixio_app/pages/app_menu.dart';
import 'package:helixio_app/pages/split_view.dart';
import 'modules/core/managers/MQTTManager.dart';
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
    // 3. watch selectedPageBuilderProvider
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return provider.ChangeNotifierProvider<MQTTManager>(
        create: (context) => serviceLocator<MQTTManager>(),
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


//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: SplitView(
//         menu: const AppMenu(),
//         content: selectedPageBuilder(context),
//       ),
//     );
//   }
// }
