// Just a simple placeholder widget page (this would be something more useful in a real app)
import 'package:flutter/material.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Control',
        body: Wrap(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Arm'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(240, 80),
                      primary: Colors.deepOrange),
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Takeoff'),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start'),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Hold'),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Land'),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Return'),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(240, 80)),
                )),
          ],
        ));
  }
}
