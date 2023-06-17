import 'package:get_it/get_it.dart';
import 'package:where_are_they/locator_service.dart';

class IoCSetup {
  void setup() {
    GetIt.I.registerSingleton<LocatorService>(LocatorService());
  }
}
