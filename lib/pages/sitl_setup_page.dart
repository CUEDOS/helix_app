import 'package:flutter/material.dart';
import 'dart:io';

import 'package:helixio_app/pages/page_scaffold.dart';

// class SITLSetupPage extends StatelessWidget {
//   const SITLSetupPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PageScaffold(
//       title: 'SITL Setup',
//       body: Center(
//           child:
//               //Text('SITL Setup', style: Theme.of(context).textTheme.headline4),
//               ElevatedButton(
//         onPressed: () {
//           _launchSim();
//         },
//         child: const Text('Launch Simulation'),
//       )),
//     );
//   }

//   void _launchSim() {
//     //Process.run('ls', ['l']);
//     Process.run(
//         'bash', ['gazebo_sitl_multiple_run.sh', '-n', '3', '-w', 'hough_end'],
//         workingDirectory: '/home/r32401vc/CASCADE/Firmware/Tools');
//   }
// }

class SITLSetupPage extends StatefulWidget {
  const SITLSetupPage({Key? key}) : super(key: key);

  @override
  State<SITLSetupPage> createState() => _SITLSetupPageState();
}

class _SITLSetupPageState extends State<SITLSetupPage> {
  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      title: 'SITL Setup',
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
  double _currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
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
                          value: _currentSliderValue,
                          max: 10,
                          divisions: 10,
                          label: _currentSliderValue.toInt().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_currentSliderValue.toInt().toString()),
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
    Process.run(
      'bash',
      ['gazebo_sitl_multiple_run.sh', '-n', '3', '-w', 'hough_end'],
      workingDirectory: '/home/r32401vc/CASCADE/Firmware/Tools',
      runInShell: true,
    );
  }
}
