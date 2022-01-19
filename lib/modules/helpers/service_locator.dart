import 'package:helixio_app/modules/core/managers/MQTTManager.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;
void setupLocator() {
  serviceLocator.registerLazySingleton(() => MQTTManager());
}
