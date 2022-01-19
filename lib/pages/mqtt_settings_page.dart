//import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helixio_app/modules/core/managers/MQTTManager.dart';
import 'package:helixio_app/modules/core/models/MQTTAppState.dart';
import 'package:helixio_app/modules/core/widgets/status_bar.dart';
import 'package:helixio_app/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _hostTextController = TextEditingController();
  late MQTTManager _manager;

  @override
  void dispose() {
    _hostTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return PageScaffold(
        //appBar: _buildAppBar(context) as PreferredSizeWidget?,
        title: 'MQTT Settings',
        // body: _manager.currentState == null
        //     ? const CircularProgressIndicator()
        //     : _buildColumn(_manager));
        body: _buildColumn(_manager));
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
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
          _buildTextFieldWith(_hostTextController, 'Enter broker address',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    } else if (controller == _hostTextController && _manager.host != null) {
      _hostTextController.text = _manager.host!;
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

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
            ),
            child: const Text('Disconnect'),
            onPressed: state != MQTTAppConnectionState.disconnected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    _manager.initializeMQTTClient(
        host: _hostTextController.text, identifier: osPrefix);
    _manager.connect();
  }

  void _disconnect() {
    _manager.disconnect();
  }
}
