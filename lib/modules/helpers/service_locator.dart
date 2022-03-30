import 'package:get_it/get_it.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'package:helixio_app/modules/core/managers/experiment_manager.dart';

GetIt serviceLocator = GetIt.instance;
void setupLocator() {
  serviceLocator.registerLazySingleton(() => MQTTManager());
  serviceLocator.registerLazySingleton(() => SwarmManager());
  serviceLocator.registerLazySingleton(() => ExperimentManager());
}
