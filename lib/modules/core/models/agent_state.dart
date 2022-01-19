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
  int _batteryLevel = 0;
  int _wifiStrength = 0;
  //String _currentCommand = 'none';
  agentCommand _currentCommand = agentCommand.none;

  AgentState(this._agentID);

  void setConnected(bool connected) {
    _connected = connected;
  }

  void setBatteryLevel(int batteryLevel) {
    _batteryLevel = batteryLevel;
  }

  void setWifiStrength(int wifiStrength) {
    _wifiStrength = wifiStrength;
  }

  void setCurrentCommand(agentCommand currentCommand) {
    _currentCommand = currentCommand;
  }

  String get getAgentID => _agentID;
  bool get getConnected => _connected;
  int get getBatteryLevel => _batteryLevel;
  int get getWifiStrength => _wifiStrength;
  agentCommand get getCurrentCommand => _currentCommand;
}
