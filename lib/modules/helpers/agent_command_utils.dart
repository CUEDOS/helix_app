import 'package:helixio_app/modules/core/models/agent_state.dart';

String prepareAgentStateMessageFrom(agentCommand state) {
  switch (state) {
    case agentCommand.none:
      return 'NONE';
    case agentCommand.arm:
      return 'ARMED';
    case agentCommand.takeoff:
      return 'TAKEOFF';
    case agentCommand.hold:
      return 'HOLD';
    case agentCommand.returnHome:
      return 'RETURN';
    case agentCommand.land:
      return 'LAND';
  }
}
