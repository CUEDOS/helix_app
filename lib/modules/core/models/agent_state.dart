enum agentCommand {
  none,
  arm,
  takeoff,
  hold,
  returnHome,
  land,
}

class AgentState {
  //String _receivedText = '';
  //String _historyText = '';
  final String _agentID;
  bool _connected = false;
  String _connectionStatus = 'Disconnected';
  String _flightMode = 'NONE';
  int _batteryLevel = 0;
  int _wifiStrength = 0;
  //String _currentCommand = 'none';
  agentCommand _currentCommand = agentCommand.none;

  AgentState(this._agentID);

  void setConnected(String connectionStatus) {
    _connectionStatus = connectionStatus;

    if (connectionStatus == 'Connected') {
      _connected = true;
    } else {
      _connected = false;
    }
  }

  void setBatteryLevel(int batteryLevel) {
    _batteryLevel = batteryLevel;
  }

  void setWifiStrength(int wifiStrength) {
    _wifiStrength = wifiStrength;
  }

  void setFlightMode(String flightMode) {
    _flightMode = flightMode;
  }

  void setCurrentCommand(agentCommand currentCommand) {
    _currentCommand = currentCommand;
  }

  String get getAgentID => _agentID;
  bool get getConnected => _connected;
  String get getConnectionStatus => _connectionStatus;
  int get getBatteryLevel => _batteryLevel;
  int get getWifiStrength => _wifiStrength;
  String get getFlightMode => _flightMode;
  agentCommand get getCurrentCommand => _currentCommand;
}
