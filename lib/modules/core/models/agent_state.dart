import 'package:latlng/latlng.dart';

enum agentCommand {
  none,
  arm,
  takeoff,
  hold,
  returnHome,
  land,
}

class AgentState {
  final String _agentID;
  bool _connected = false;
  String _connectionStatus = 'Disconnected';
  String _flightMode = 'NONE';
  int _batteryLevel = 0;
  int _wifiStrength = 0;
  LatLng _latLng = LatLng(0, 0);
  double _heading = 0;
  double _absoluteAltitude = 0;
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

  void setGeodetic(LatLng latLng, double absoluteAltitude) {
    _latLng = latLng;
    _absoluteAltitude = absoluteAltitude;
  }

  void setHeading(double heading) {
    _heading = heading;
  }

  String get getAgentID => _agentID;
  bool get getConnected => _connected;
  String get getConnectionStatus => _connectionStatus;
  int get getBatteryLevel => _batteryLevel;
  int get getWifiStrength => _wifiStrength;
  String get getFlightMode => _flightMode;
  LatLng get getLatLng => _latLng;
  double get getabsoluteAltitude => _absoluteAltitude;
  double get getHeading => _heading;
  agentCommand get getCurrentCommand => _currentCommand;
}
