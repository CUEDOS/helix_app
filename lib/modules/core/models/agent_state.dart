import 'package:latlng/latlng.dart';
import 'package:helixio_app/modules/helpers/coordinate_conversions.dart'
    show NED;

enum agentCommand {
  none,
  arm,
  takeoff,
  hold,
  returnHome,
  land,
}

class SwarmingGains {
  double kMigration;
  double kLaneCohesion;
  double kRotation;
  double kSeperation;

  SwarmingGains(
      this.kLaneCohesion, this.kMigration, this.kRotation, this.kSeperation);
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
  NED _positionNed = NED(0, 0, 0);
  bool _armStatus = false;
  Map<String, double> _closeTo = {};
  agentCommand _currentCommand = agentCommand.none;
  SwarmingGains _swarmingGains = SwarmingGains(0, 0, 0, 0);
  List<String> _experimentFiles = [];
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

  void setNED(NED positionNed) {
    _positionNed = positionNed;
  }

  void setArmStatus(bool armStatus) {
    _armStatus = armStatus;
  }

  void addCloseTo(String id, double distance) {
    _closeTo[id] = distance;
  }

  void removeCloseTo(String id) {
    _closeTo.remove(id);
  }

  void setHeading(double heading) {
    _heading = heading;
  }

  void setSwarmingGains(SwarmingGains swarmingGains) {
    _swarmingGains = swarmingGains;
  }

  void setExperimentFiles(List<String> experimentFiles) {
    _experimentFiles = experimentFiles;
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
  NED get getNED => _positionNed;
  bool get getArmStatus => _armStatus;
  Map<String, double> get getCloseTo => _closeTo;
  SwarmingGains get getSwarmingGains => _swarmingGains;
  agentCommand get getCurrentCommand => _currentCommand;
  List<String> get getExperimentFiles => _experimentFiles;
}
