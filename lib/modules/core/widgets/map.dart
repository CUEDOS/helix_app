import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        child: Consumer<SwarmManager>(builder: (context, swarmManager, child) {
          LatLng agentLatLng;
          if (swarmManager.swarm[0] != null) {
            agentLatLng = swarmManager.swarm[0]!.getLatLng;
          } else {
            agentLatLng = LatLng(53.43578053111544, -2.250343561172483);
          }
          return FlutterMap(
              options: MapOptions(
                center: LatLng(53.43578053111544, -2.250343561172483),
                zoom: 15,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                        width: 80.0,
                        height: 80.0,
                        //point: LatLng(53.43578053111544, -2.250343561172483),
                        point: agentLatLng,
                        builder: (ctx) => Container(
                              child: Row(
                                children: const [
                                  Icon(Icons.airplanemode_active),
                                  Text('P101'),
                                ],
                              ),
                              //const Text('P101'),
                            )),
                  ],
                )
              ]);
        }),
      ),
    );
  }
}
