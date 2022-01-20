import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';

class SwarmSetupPage extends StatefulWidget {
  const SwarmSetupPage({Key? key}) : super(key: key);

  @override
  State<SwarmSetupPage> createState() => _SwarmSetupPageState();
}

class _SwarmSetupPageState extends State<SwarmSetupPage> {
  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      title: 'Swarm Setup',
      body: SwarmSizeSlider(),
    );
  }
}

class SwarmSizeSlider extends StatefulWidget {
  const SwarmSizeSlider({Key? key}) : super(key: key);

  @override
  State<SwarmSizeSlider> createState() => _SwarmSizeSliderState();
}

class _SwarmSizeSliderState extends State<SwarmSizeSlider> {
  late SwarmManager _swarmManager;
  //double _currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    _swarmManager = Provider.of<SwarmManager>(context);
    return Column(
      children: [
        const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Swarm Size'),
            )),
        Flexible(
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _swarmManager.swarmSize.toDouble(),
                          max: 10,
                          divisions: 10,
                          label: _swarmManager.swarmSize.toString(),
                          onChanged: (double value) {
                            setState(() {
                              _swarmManager.swarmSize = value.toInt();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_swarmManager.swarmSize.toString()),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _swarmManager.initialiseSwarm(_swarmManager
                              .swarmSize); //not good practice to pass a variable from the class back
                          //into the method but it works, fix later
                        },
                        child: const Text('Confirm'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
