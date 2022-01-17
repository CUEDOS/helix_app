import 'package:flutter/material.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Control'),
        ),
        body: const Controls());
  }
}

class Controls extends StatelessWidget {
  const Controls({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Arm'),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(240, 80), primary: Colors.deepOrange),
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Takeoff'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Start'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Hold'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Land'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Return'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
            )),
      ],
    );
  }
}
