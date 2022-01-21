import 'package:flutter/material.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/models/mqtt_app_state.dart';
import 'package:helixio_app/modules/core/models/agent_state.dart';
import 'package:helixio_app/modules/core/widgets/status_bar.dart';
import 'package:helixio_app/modules/helpers/status_info_message_utils.dart';
import 'package:helixio_app/modules/helpers/agent_command_utils.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String _dropdownValue = 'Simple Flocking';
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();

  late MQTTManager _manager;

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return PageScaffold(title: 'Control', body: _buildColumn(_manager));
  }

  Widget _buildColumn(MQTTManager manager) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      primary: false,
      child: Column(
        children: <Widget>[
          StatusBar(
              statusMessage: prepareMQTTStateMessageFrom(
                  manager.currentState.getAppConnectionState)),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              children: [
                _buildControlButton(
                    manager.currentState.getAppConnectionState, 'Arm', 'arm'),
                _buildControlButton(manager.currentState.getAppConnectionState,
                    'Takeoff', 'takeoff'),
                _buildControlButton(
                    manager.currentState.getAppConnectionState, 'Hold', 'hold'),
                _buildControlButton(manager.currentState.getAppConnectionState,
                    'Return', 'return'),
                _buildControlButton(
                    manager.currentState.getAppConnectionState, 'Land', 'land'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _dropdownValue,
                  icon: const Icon(Icons.airplanemode_active),
                  hint: const Text('Select Command'),
                  items: <String>[
                    'Simple Flocking',
                    'Circle Helix',
                    'Racetrack Helix',
                    'Figure 8',
                    'Double Racetrack'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                ),
                _buildControlButton(manager.currentState.getAppConnectionState,
                    'Start', _dropdownValue),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Consumer<SwarmManager>(
              builder: (context, swarmManager, child) {
                return Wrap(
                    //alignment: WrapAlignment.start,
                    children: _buildInfoCardList(swarmManager.swarm.values));
              },
            ),
          ),
        ],
      ),
    );
  }

//wrap widget requires list of widgets so need to return list of cards from this function
  List<Widget> _buildInfoCardList(Iterable<AgentState> agents) {
    List<Widget> infoCards = [];
    for (AgentState agent in agents) {
      infoCards.add(_buildInfoCard(agent));
    }
    return infoCards;
  }

  Widget _buildControlButton(
      MQTTAppConnectionState state, String buttonText, String command) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(88, 36),
            //primary: Colors.deepOrange
          ),
          onPressed: state == MQTTAppConnectionState.connected ||
                  state == MQTTAppConnectionState.connectedSubscribed
              ? () {
                  _publishMessage('commands', command);
                }
              : null,
        ));
  }

  Widget _buildInfoCard(AgentState _agentState) {
    return SizedBox(
      width: 150.0,
      //height: 300.0,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //dense: true,
              //leading: Icon(Icons.airplanemode_active),
              title: Text(_agentState.getAgentID),
              subtitle: Text(_agentState.getConnectionStatus),
            ),
            const Divider(
              height: 0,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: Colors.grey,
            ),
            //const SizedBox(width: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.battery_full_sharp),
                      Text(_agentState.getBatteryLevel.toString() + '%'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.wifi),
                      Text(_agentState.getWifiStrength.toString() + 'dB'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.airplanemode_active),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      color: Colors.green,
                      child: Center(
                          child: Text(prepareAgentStateMessageFrom(
                              _agentState.getCurrentCommand))),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: const Text('SELECT'),
                onPressed: () {/* ... */},
              ),
            ),
            //const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _publishMessage(String topic, String message) {
    _manager.publish(topic, message);
    _messageTextController.clear();
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
