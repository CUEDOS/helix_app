import 'package:flutter/material.dart';
//import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/helpers/coordinate_conversions.dart';
import 'package:helixio_app/modules/core/secrets/keys.dart';
//import 'package:helixio_app/modules/core/models/agent_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:helixio_app/modules/core/managers/experiment_manager.dart';

class ExperimentSetupMap extends StatefulWidget {
  const ExperimentSetupMap({Key? key}) : super(key: key);
  //final SwarmManager swarmManager;

  @override
  _ExperimentSetupMapState createState() => _ExperimentSetupMapState();
}

class _ExperimentSetupMapState extends State<ExperimentSetupMap> {
  final controller = MapController(
    //location: LatLng(53.43578053111544, -2.250343561172483),
    location: LatLng(52.81651946850575, -4.124781265539541),
  );

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

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
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
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 11.5,
      top: pos.dy - 12.7,
      width: 24,
      height: 24,
      child: Icon(Icons.my_location, color: color, size: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapLayout(
      controller: controller,
      builder: (context, transformer) {
        //List<Widget> Flag = [];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
          onTapUp: (details) {
            final location = transformer.toLatLng(details.localPosition);

            final clicked = transformer.toOffset(location);

            //selectedLocation = location;
            serviceLocator<SwarmManager>().setReferencePoint(location);
            setState(() {});

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
                    final url =
                        'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/$z/$x/$y?access_token=' +
                            mapBoxApiKey;

                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                CustomPaint(
                  painter: PolylinePainter(transformer),
                ),
                _buildMarkerWidget(
                    transformer.toOffset(
                        serviceLocator<SwarmManager>().getReferencePoint),
                    Colors.white)
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
  }
}

class PolylinePainter extends CustomPainter {
  PolylinePainter(this.transformer);

  final MapTransformer transformer;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2;

    // var p1 = ned2Geodetic(NED(0, 0, 20),
    //         Geodetic(LatLng(53.43578053111544, -2.250343561172483), 31))
    //     .latLng;
    // var p2 = ned2Geodetic(NED(20, 20, 20),
    //         Geodetic(LatLng(53.43578053111544, -2.250343561172483), 31))
    //     .latLng;

    serviceLocator<ExperimentManager>().generatePointsForMap();
    for (int i = 0;
        i < serviceLocator<ExperimentManager>().pointsForMap.length;
        i++) {
      List<double> currentPoint =
          serviceLocator<ExperimentManager>().pointsForMap[i];
      List<double> nextPoint;

      if (i != serviceLocator<ExperimentManager>().pointsForMap.length - 1) {
        nextPoint = serviceLocator<ExperimentManager>().pointsForMap[i + 1];
      } else {
        nextPoint = serviceLocator<ExperimentManager>().pointsForMap[0];
      }

      var p1 = ned2Geodetic(
              NED(currentPoint[0], currentPoint[1], currentPoint[2]),
              Geodetic(serviceLocator<SwarmManager>().getReferencePoint, 31))
          .latLng;
      var p2 = ned2Geodetic(NED(nextPoint[0], nextPoint[1], nextPoint[2]),
              Geodetic(serviceLocator<SwarmManager>().getReferencePoint, 31))
          .latLng;

      canvas.drawLine(
          transformer.toOffset(p1), transformer.toOffset(p2), paint);
    }
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(PolylinePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(PolylinePainter oldDelegate) => false;
}
