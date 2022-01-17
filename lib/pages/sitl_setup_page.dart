import 'package:flutter/material.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class SITLSetupPage extends StatelessWidget {
  const SITLSetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'SITL Setup',
      body: Center(
        child: Text('SITL Setup', style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}
