import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/models/mqtt_app_state.dart';
import 'package:helixio_app/modules/core/widgets/status_bar.dart';
import 'package:helixio_app/modules/helpers/status_info_message_utils.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class MQTTConsolePage extends StatefulWidget {
  const MQTTConsolePage({Key? key}) : super(key: key);

  @override
  _MQTTConsolePageState createState() => _MQTTConsolePageState();
}

class _MQTTConsolePageState extends State<MQTTConsolePage> {
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();

  late MQTTManager _mqttManager;

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mqttManager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return PageScaffold(title: 'Control', body: _buildColumn(_mqttManager));
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareMQTTStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        _buildEditableColumn(manager.currentState),
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

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: const Text('Send'),
      onPressed: state == MQTTAppConnectionState.connectedSubscribed &&
              _topicTextController.text.isNotEmpty
          ? () {
              _publishMessage(
                  _topicTextController.text, _messageTextController.text);
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
      _mqttManager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _mqttManager.subscribeTo(_topicTextController.text);
      } else {
        _showDialog("Please enter a topic.");
      }
    }
  }

  void _publishMessage(String topic, String message) {
    _mqttManager.publish(topic, message);
    _messageTextController.clear();
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
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
