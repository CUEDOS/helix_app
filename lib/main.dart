import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helixio_app/pages/app_menu.dart';
import 'package:helixio_app/pages/split_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// 1. extend from ConsumerWidget
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. watch selectedPageBuilderProvider
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplitView(
        menu: const AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );
  }
}
