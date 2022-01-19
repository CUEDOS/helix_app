//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/modules/core/managers/MQTTManager.dart';
import 'package:helixio_app/modules/core/models/MQTTAppState.dart';
import 'package:helixio_app/modules/core/widgets/status_bar.dart';
//import 'package:helixio_app/modules/helpers/screen_route.dart';
import 'package:helixio_app/modules/helpers/status_info_message_utils.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
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
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        Wrap(
          children: [
            _buildControlButton(
                manager.currentState.getAppConnectionState, 'Arm', 'arm'),
            _buildControlButton(manager.currentState.getAppConnectionState,
                'Takeoff', 'takeoff'),
            _buildControlButton(
                manager.currentState.getAppConnectionState, 'Hold', 'hold'),
            _buildControlButton(
                manager.currentState.getAppConnectionState, 'Return', 'return'),
            _buildControlButton(
                manager.currentState.getAppConnectionState, 'Start', 'start'),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
              //alignment: WrapAlignment.start,
              children: <Widget>[
                _buildInfoCard('P101', 'Disconnected'),
                _buildInfoCard('P102', 'Disconnected'),
                _buildInfoCard('P103', 'Disconnected'),
              ]),
        ),
      ],
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTopicSubscribeRow(currentAppState),
          const SizedBox(height: 10),
          _buildPublishMessageRow(currentAppState),
          const SizedBox(height: 10),
          _buildScrollableTextWith(currentAppState.getHistoryText)
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(_messageTextController, 'Enter a message',
              currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connectedSubscribed) {
      shouldEnable = true;
    } else if ((controller == _topicTextController &&
        (state == MQTTAppConnectionState.connected ||
            state == MQTTAppConnectionState.connectedUnSubscribed))) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildControlButton(
      MQTTAppConnectionState state, String buttonText, String command) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(88, 36), primary: Colors.deepOrange),
          onPressed: state == MQTTAppConnectionState.connectedSubscribed
              ? () {
                  _publishMessage(command);
                }
              : null,
        ));
  }

  Widget _buildInfoCard(String droneID, String connectionStatus) {
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
              title: Text(droneID),
              subtitle: Text(connectionStatus),
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
                    children: const [
                      Icon(Icons.battery_full_sharp),
                      Text('100%'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.wifi),
                      Text('50dB'),
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
                      child: const Center(child: Text('DISARMED')),
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

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: const Text('Send'),
      onPressed: state == MQTTAppConnectionState.connectedSubscribed
          ? () {
              _publishMessage(_messageTextController.text);
            }
          : null, //
    );
  }

  Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(
              _topicTextController,
              'Enter a topic to subscribe or listen',
              currentAppState.getAppConnectionState),
        ),
        _buildSubscribeButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: state == MQTTAppConnectionState.connectedSubscribed
          ? const Text('Unsubscribe')
          : const Text('Subscribe'),
      onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
              (state == MQTTAppConnectionState.connectedUnSubscribed) ||
              (state == MQTTAppConnectionState.connected)
          ? () {
              _handleSubscribePress(state);
            }
          : null, //
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: SingleChildScrollView(
          controller: _controller,
          child: Text(text),
        ),
      ),
    );
  }

  void _handleSubscribePress(MQTTAppConnectionState state) {
    if (state == MQTTAppConnectionState.connectedSubscribed) {
      _manager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _manager.subScribeTo(_topicTextController.text);
      } else {
        _showDialog("Please enter a topic.");
      }
    }
  }

  void _publishMessage(String message) {
    _manager.publish(message);
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
