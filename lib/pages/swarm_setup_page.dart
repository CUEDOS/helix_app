import 'package:flutter/material.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class SwarmSetupPage extends StatelessWidget {
  const SwarmSetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Swarm Setup',
      body: Center(
        child:
            Text('Swarm Setup', style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}
