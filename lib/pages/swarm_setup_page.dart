import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/models/mqtt_app_state.dart';
import 'package:helixio_app/modules/core/widgets/error_dialog.dart';

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
  late MQTTManager _mqttManager;
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
                          _handleConfirmPress();
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

  void _handleConfirmPress() {
    _mqttManager = Provider.of<MQTTManager>(context, listen: false);
    if (_mqttManager.currentState.getAppConnectionState ==
        MQTTAppConnectionState.connected) {
      _swarmManager.initialiseSwarm(_swarmManager.swarmSize, _mqttManager);
      //not good practice to pass a variable from the class back
      ////into the method but it works, fix later
    } else {
      displayErrorDialog('Connect to a broker first!', context);
    }
  }
}
