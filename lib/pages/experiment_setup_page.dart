import 'package:flutter/material.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/helpers/round_double.dart';
import 'package:helixio_app/modules/helpers/corridor_generators.dart';
import 'dart:convert';
//import 'package:provider/provider.dart';

import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:latlng/latlng.dart';
import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:helixio_app/modules/core/managers/experiment_manager.dart';
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
  //String experimentType = 'Single';
  static const double labelBoxWidth = 70;
  //double corridorRadius = 1;
  //double majorRadiusSliderValue = 1;
  //double minorRadiusSliderValue = 1;
  //int pointsNumberSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: serviceLocator<ExperimentManager>().selectedExperimentType,
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
              serviceLocator<ExperimentManager>().selectedExperimentType =
                  newValue!;
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
                value: serviceLocator<ExperimentManager>().corridorRadius,
                min: 1,
                max: 20,
                label: serviceLocator<ExperimentManager>()
                    .corridorRadius
                    .toString(),
                onChanged: (double value) {
                  setState(() {
                    serviceLocator<ExperimentManager>().corridorRadius =
                        roundDouble(value, 1);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(serviceLocator<ExperimentManager>()
                  .corridorRadius
                  .toString()),
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
                value: serviceLocator<ExperimentManager>().selectedMajorRadius,
                min: 1,
                max: 50,
                //divisions: 10,
                label: serviceLocator<ExperimentManager>()
                    .selectedMajorRadius
                    .toString(),
                onChanged: (double value) {
                  setState(() {
                    serviceLocator<ExperimentManager>().selectedMajorRadius =
                        roundDouble(value, 1);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(serviceLocator<ExperimentManager>()
                  .selectedMajorRadius
                  .toString()),
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
                value: serviceLocator<ExperimentManager>().selectedMinorRadius,
                min: 1,
                max: 50,
                //divisions: 10,
                label: serviceLocator<ExperimentManager>()
                    .selectedMinorRadius
                    .toString(),
                onChanged: (double value) {
                  setState(() {
                    serviceLocator<ExperimentManager>().selectedMinorRadius =
                        roundDouble(value, 2);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(serviceLocator<ExperimentManager>()
                  .selectedMinorRadius
                  .toString()),
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
                value: serviceLocator<ExperimentManager>()
                    .selectedPointsNumber
                    .toDouble(),
                min: 1,
                max: 5000,
                //divisions: 10,
                label: serviceLocator<ExperimentManager>()
                    .selectedPointsNumber
                    .toString(),
                onChanged: (double value) {
                  setState(() {
                    //PointsNumberSliderValue = roundDouble(value, 0);
                    serviceLocator<ExperimentManager>().selectedPointsNumber =
                        value.toInt();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(serviceLocator<ExperimentManager>()
                  .selectedPointsNumber
                  .toString()),
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
                //_uploadCorridor();
                uploadParameters();
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

    switch (serviceLocator<ExperimentManager>().selectedExperimentType) {
      case 'Single':
        {
          List<List<double>> corridorPoints = singleEllipse(
              serviceLocator<ExperimentManager>().selectedPointsNumber,
              serviceLocator<ExperimentManager>().selectedMajorRadius,
              serviceLocator<ExperimentManager>().selectedMinorRadius);

          corridor = {
            'corridor_radius':
                serviceLocator<ExperimentManager>().corridorRadius,
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
              serviceLocator<ExperimentManager>().selectedPointsNumber,
              serviceLocator<ExperimentManager>().selectedMajorRadius,
              serviceLocator<ExperimentManager>().selectedMinorRadius,
              serviceLocator<ExperimentManager>().selectedMajorRadius);

          corridor = {
            'corridor_radius':
                serviceLocator<ExperimentManager>().corridorRadius,
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

void uploadParameters() {
  //serviceLocator<MQTTManager>().publish(topic, message);
  //TODO clean up a bit by putting this in swarm manager
  LatLng refLatLng = serviceLocator<SwarmManager>().getReferencePoint;
  Map<String, dynamic> parameters = {
    'ref_lat': refLatLng.latitude,
    'ref_lon': refLatLng.longitude
  };
  var swarm = serviceLocator<SwarmManager>().swarm;
  List<String> selected = serviceLocator<SwarmManager>().selected;
  String parametersJson = jsonEncode(parameters);

  if (selected.isEmpty) {
    for (String agent in swarm.keys) {
      serviceLocator<MQTTManager>()
          .publish(agent + '/update_parameters', parametersJson);
    }
  } else {
    for (String agent in selected) {
      serviceLocator<MQTTManager>()
          .publish(agent + '/update_parameters', parametersJson);
    }
  }
}
