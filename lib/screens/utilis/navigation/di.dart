import 'package:get_it/get_it.dart';
import 'navigation_service.dart';

setupSharedServices(GetIt ioc) {
  ioc.registerSingleton<NavigationService>(NavigationService());
}
