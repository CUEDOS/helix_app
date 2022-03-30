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

class ExperimentSetupMap extends StatefulWidget {
  const ExperimentSetupMap({Key? key}) : super(key: key);
  //final SwarmManager swarmManager;

  @override
  _ExperimentSetupMapState createState() => _ExperimentSetupMapState();
}

class _ExperimentSetupMapState extends State<ExperimentSetupMap> {
  final controller = MapController(
    location: LatLng(53.43578053111544, -2.250343561172483),
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

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.my_location, color: color, size: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapLayoutBuilder(
      controller: controller,
      builder: (context, transformer) {
        //List<Widget> Flag = [];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onTapUp: (details) {
            final location =
                transformer.fromXYCoordsToLatLng(details.localPosition);

            final clicked = transformer.fromLatLngToXYCoords(location);

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
                    //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                    //Google Maps
                    final url =
                        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                _buildMarkerWidget(
                    transformer.fromLatLngToXYCoords(
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
