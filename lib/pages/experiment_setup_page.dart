import 'package:flutter/material.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/helpers/round_double.dart';
//import 'package:provider/provider.dart';

import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:helixio_app/modules/core/models/agent_state.dart';
//import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
//import 'package:helixio_app/modules/core/models/mqtt_app_state.dart';
//import 'package:helixio_app/modules/core/widgets/error_dialog.dart';

class ExperimentSetupPage extends StatefulWidget {
  const ExperimentSetupPage({Key? key}) : super(key: key);

  @override
  State<ExperimentSetupPage> createState() => _ExperimentSetupPageState();
}

class _ExperimentSetupPageState extends State<ExperimentSetupPage> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Experiment Setup',
        body: Column(
          children: [
            SwarmingSettingsCard(agentState: AgentState('P101')),
            const SwarmingGainEntry(),
          ],
        ));
  }
}

class SwarmingGainEntry extends StatefulWidget {
  const SwarmingGainEntry({Key? key}) : super(key: key);
  @override
  State<SwarmingGainEntry> createState() => _SwarmingGainEntryState();
}

class _SwarmingGainEntryState extends State<SwarmingGainEntry> {
  static const double labelBoxWidth = 70;
  double migrationSliderValue = 0;
  double laneCohesionSliderValue = 0;
  double rotationSliderValue = 0;
  double seperationSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(width: labelBoxWidth, child: Text('Migration')),
              ),
              Expanded(
                child: Slider(
                  value: migrationSliderValue,
                  max: 5,
                  //divisions: 10,
                  label: migrationSliderValue.toString(),
                  onChanged: (double value) {
                    setState(() {
                      migrationSliderValue = roundDouble(value, 2);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(migrationSliderValue.toString()),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    width: labelBoxWidth, child: Text('Lane Cohesion')),
              ),
              Expanded(
                child: Slider(
                  value: laneCohesionSliderValue,
                  max: 5,
                  //divisions: 10,
                  label: laneCohesionSliderValue.toString(),
                  onChanged: (double value) {
                    setState(() {
                      laneCohesionSliderValue = roundDouble(value, 2);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(laneCohesionSliderValue.toString()),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(width: labelBoxWidth, child: Text('Rotation')),
              ),
              Expanded(
                child: Slider(
                  value: rotationSliderValue,
                  max: 5,
                  //divisions: 10,
                  label: rotationSliderValue.toString(),
                  onChanged: (double value) {
                    setState(() {
                      rotationSliderValue = roundDouble(value, 2);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(rotationSliderValue.toString()),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    SizedBox(width: labelBoxWidth, child: Text('Seperation')),
              ),
              Expanded(
                child: Slider(
                  value: seperationSliderValue,
                  max: 5,
                  //divisions: 10,
                  label: seperationSliderValue.toString(),
                  onChanged: (double value) {
                    setState(() {
                      seperationSliderValue = roundDouble(value, 2);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(seperationSliderValue.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SwarmingSettingsCard extends StatefulWidget {
  const SwarmingSettingsCard({Key? key, required this.agentState})
      : super(key: key);
  final AgentState agentState;

  @override
  SwarmingSettingsCardState createState() => SwarmingSettingsCardState();
}

class SwarmingSettingsCardState extends State<SwarmingSettingsCard> {
  String _buttonText = 'SELECT';
  bool _selected = false;

  toggleSelected() {
    if (_buttonText == 'SELECT') {
      setState(() {
        _selected = true;
        _buttonText = 'UNSELECT';
        serviceLocator<SwarmManager>()
            .addSelected(widget.agentState.getAgentID);
      });
    } else {
      _selected = false;
      _buttonText = 'SELECT';
      serviceLocator<SwarmManager>()
          .removeSelected(widget.agentState.getAgentID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      //height: 300.0,
      child: Card(
        shape: _selected
            ? RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(4.0))
            : RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //dense: true,
              //leading: Icon(Icons.airplanemode_active),
              title: Text(widget.agentState.getAgentID),
              subtitle: Text(widget.agentState.getConnectionStatus),
            ),
            const Divider(
              height: 0,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Migration '),
                      Text(widget.agentState.getSwarmingGains.kMigration
                          .toString())
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Lane Cohesion '),
                      Text(widget.agentState.getSwarmingGains.kLaneCohesion
                          .toString())
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Rotation '),
                      Text(widget.agentState.getSwarmingGains.kRotation
                          .toString())
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Seperation '),
                      Text(widget.agentState.getSwarmingGains.kSeperation
                          .toString())
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(_buttonText),
                onPressed: () {
                  toggleSelected();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
