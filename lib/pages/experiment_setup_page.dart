import 'package:flutter/material.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/helpers/round_double.dart';
import 'package:helixio_app/modules/helpers/corridor_generators.dart';
import 'dart:convert';
//import 'package:provider/provider.dart';

import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
//import 'package:helixio_app/modules/core/models/agent_state.dart';
//import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
//import 'package:helixio_app/modules/core/models/mqtt_app_state.dart';
import 'package:helixio_app/modules/core/widgets/experiment_setup_map.dart';

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
            Container(height: 300.0, child: ExperimentSetupMap()),
            const ExperimentSetupEntry()
          ],
        ));
  }
}

class ExperimentSetupEntry extends StatefulWidget {
  const ExperimentSetupEntry({Key? key}) : super(key: key);

  @override
  State<ExperimentSetupEntry> createState() => _ExperimentSetupEntryState();
}

class _ExperimentSetupEntryState extends State<ExperimentSetupEntry> {
  String experimentType = 'Single';
  static const double labelBoxWidth = 70;
  double corridorRadius = 1;
  double majorRadiusSliderValue = 1;
  double minorRadiusSliderValue = 1;
  int pointsNumberSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: experimentType,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              experimentType = newValue!;
            });
          },
          items: <String>['Single', 'Double', 'Figure 8', 'Line']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  width: labelBoxWidth, child: Text('Corridor Radius')),
            ),
            Expanded(
              child: Slider(
                value: corridorRadius,
                min: 1,
                max: 20,
                label: corridorRadius.toString(),
                onChanged: (double value) {
                  setState(() {
                    corridorRadius = roundDouble(value, 1);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(corridorRadius.toString()),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  SizedBox(width: labelBoxWidth, child: Text('Major Radius')),
            ),
            Expanded(
              child: Slider(
                value: majorRadiusSliderValue,
                min: 1,
                max: 50,
                //divisions: 10,
                label: majorRadiusSliderValue.toString(),
                onChanged: (double value) {
                  setState(() {
                    majorRadiusSliderValue = roundDouble(value, 1);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(majorRadiusSliderValue.toString()),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  SizedBox(width: labelBoxWidth, child: Text('Minor Radius')),
            ),
            Expanded(
              child: Slider(
                value: minorRadiusSliderValue,
                min: 1,
                max: 50,
                //divisions: 10,
                label: minorRadiusSliderValue.toString(),
                onChanged: (double value) {
                  setState(() {
                    minorRadiusSliderValue = roundDouble(value, 2);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(minorRadiusSliderValue.toString()),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  width: labelBoxWidth, child: Text('Number of Points')),
            ),
            Expanded(
              child: Slider(
                value: pointsNumberSliderValue.toDouble(),
                min: 1,
                max: 5000,
                //divisions: 10,
                label: pointsNumberSliderValue.toString(),
                onChanged: (double value) {
                  setState(() {
                    //PointsNumberSliderValue = roundDouble(value, 0);
                    pointsNumberSliderValue = value.toInt();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(pointsNumberSliderValue.toString()),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(88, 36),
                //primary: Colors.deepOrange
              ),
              onPressed: () {
                _uploadCorridor();
              },
            ))
      ],
    );
  }

  void _uploadCorridor() {
    //serviceLocator<MQTTManager>().publish(topic, message);
    var swarm = serviceLocator<SwarmManager>().swarm;
    List<String> selected = serviceLocator<SwarmManager>().selected;
    //String corridorPointsJson = '';
    Map corridor = {};
    String corridorJson = '';

    switch (experimentType) {
      case 'Single':
        {
          List<List<double>> corridorPoints = singleEllipse(
              pointsNumberSliderValue,
              majorRadiusSliderValue,
              minorRadiusSliderValue);

          corridor = {
            'corridor_radius': corridorRadius,
            'corridor_points': corridorPoints
          };
          corridorJson = jsonEncode(corridor);
        }
        break;

      case 'Double':
        {
          //statements;
        }
        break;

      case 'Figure 8':
        {
          List<List<double>> corridorPoints = figureEight(
              pointsNumberSliderValue,
              majorRadiusSliderValue,
              minorRadiusSliderValue,
              majorRadiusSliderValue);

          corridor = {
            'corridor_radius': corridorRadius,
            'corridor_points': corridorPoints
          };
          corridorJson = jsonEncode(corridor);
        }
        break;
      case 'Line':
        {
          //statements;
        }
        break;
    }
    if (selected.isEmpty) {
      for (String agent in swarm.keys) {
        serviceLocator<MQTTManager>()
            .publish(agent + '/corridor_points', corridorJson);
      }
    } else {
      for (String agent in selected) {
        serviceLocator<MQTTManager>()
            .publish(agent + '/corridor_points', corridorJson);
      }
    }
  }
}
