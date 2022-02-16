import 'package:flutter/material.dart';
//import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/core/models/agent_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:timer_builder/timer_builder.dart';
import 'dart:math' as math;

// class MapPage extends StatelessWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const PageScaffold(
//       title: 'SITL Setup',
//       body: Center(
//         child: MyMap(),
//       ),
//     );
//   }
// }

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);
  //final SwarmManager swarmManager;

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final controller = MapController(
    location: LatLng(53.43578053111544, -2.250343561172483),
  );

  bool _darkMode = false;

  // List<LatLng> _generateMarkers(SwarmManager swarmManager) {
  //   List<LatLng> markers = [];

  //   if (swarmManager.swarm.isNotEmpty) {
  //     Iterable<AgentState> agents = swarmManager.swarm.values;
  //     for (AgentState agent in agents) {
  //       markers.add(agent.getLatLng);
  //     }
  //   } else {
  //     //markers.add(LatLng(53.43578053111544, -2.250343561172483));
  //   }
  //   return markers;
  // }

  List<AgentMarker> _generateMarkers(var swarm, MapTransformer transformer) {
    List<AgentMarker> agentMarkers = [];

    if (swarm.isNotEmpty) {
      Iterable<AgentState> agents = swarm.values;
      for (AgentState agent in agents) {
        agentMarkers.add(AgentMarker(agent.getLatLng, agent.getHeading,
            transformer.fromLatLngToXYCoords(agent.getLatLng)));
      }
    }
    return agentMarkers;
  }

  void _gotoDefault() {
    controller.center = LatLng(53.43578053111544, -2.250343561172483);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, double heading, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      // child: Row(
      //   children: [
      //     const Text('SXXX'),
      //     Icon(Icons.airplanemode_active, color: color),
      //   ],
      // ),
      child: Transform.rotate(
          //convert heading in degrees to radians
          angle: heading * (math.pi / 180),
          child: Icon(Icons.airplanemode_active, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('drawing map');
    // used to update mp at set frequency rather than as fast as updates are received
    // increases performance
    return TimerBuilder.periodic(const Duration(milliseconds: 100),
        builder: (context) {
      return MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          // final markerPositions = _generateMarkers(widget.swarmManager)
          //     .map((agentMarker) =>
          //         transformer.fromLatLngToXYCoords(agentMarker.getLatLng))
          //     .toList();

          var swarm = serviceLocator<SwarmManager>().swarm;

          final markerPositions = _generateMarkers(swarm, transformer);

          final markerWidgets = markerPositions.map(
            (agentMarker) => _buildMarkerWidget(
                agentMarker.cartesian, agentMarker.heading, Colors.red),
          );

          // final homeLocation = transformer.fromLatLngToXYCoords(
          //     LatLng(53.43578053111544, -2.250343561172483));

          //final homeMarkerWidget = _buildMarkerWidget(homeLocation, Colors.black);

          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          // final centerMarkerWidget =
          //     _buildMarkerWidget(centerLocation, Colors.purple);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onTapUp: (details) {
              final location =
                  transformer.fromXYCoordsToLatLng(details.localPosition);

              final clicked = transformer.fromLatLngToXYCoords(location);

              print('${location.longitude}, ${location.latitude}');
              print('${clicked.dx}, ${clicked.dy}');
              print('${details.localPosition.dx}, ${details.localPosition.dy}');
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                      final darkUrl =
                          'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0&key=AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU&token=31440';
                      //Mapbox Streets
                      // final url =
                      //     'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=YOUR_MAPBOX_ACCESS_TOKEN';

                      return CachedNetworkImage(
                        imageUrl: _darkMode ? darkUrl : url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  //homeMarkerWidget,
                  ...markerWidgets,
                  //centerMarkerWidget,
                ],
              ),
            ),
          );
        },
      );
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _gotoDefault,
      //   tooltip: 'My Location',
      //   child: const Icon(Icons.my_location),
      //),
    });
  }
}

// Defines marker object containing position and heading
class AgentMarker {
  final LatLng latLng;
  final double heading;
  final Offset cartesian;

  AgentMarker(this.latLng, this.heading, this.cartesian);

  // LatLng get getLatLng => _latLng;
  // double get getHeading => _heading;
  // Offset get getCartesian => _cartesian;
}
