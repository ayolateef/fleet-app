import 'dart:async';

import '../models/user.dart';
import '../navigation/di.dart';
import '../storage.dart';
import 'app_configs.dart';
import 'package:get_it/get_it.dart';

enum Environment { dev, production }

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

class AppStartUp {
  Future<void> setUp() async {
    getIt.allowReassignment = true;
    //await initializedFirebase();
    await registerServices(getIt);
    loadStartUpConfig();
    //await firebasePushNotification();

    AppConstants.environment = Environment.values.firstWhere(
      (element) => element.name == const String.fromEnvironment("env"),
      orElse: () => Environment.dev,
    );
  }

  Future<void> registerServices(ioc) async {
    setupSharedServices(ioc);
    // setupAuthServices(ioc);
    // setupWalletServices(ioc);
    // setupHomeServices(ioc);
    // setupProfileService(ioc);
    // earningService(ioc);
    // addressService(ioc);
    // setupLogisticsServices(ioc);
    // setupChatService(ioc);
    // setupNotifications(ioc);
  }

  void loadStartUpConfig() async {
    var userObject =
        await LocalStorageUtils.readObject<User>(AppConstants.userObject);
    if (userObject != null) {
      User user = User.fromJson(userObject);
      getIt.registerSingleton<User>(user);

      //! Note: this has to be called after SignInCubit is registered
      //getIt.get<SignInCubit>().getProfile(isLogin: true);
    }
  }

// Future<void> initializedFirebase() async {
//   await Firebase.initializeApp();
// }
//
// Future<void> firebasePushNotification() async {
//   FirebaseNotificationManager notificationManager =
//       FirebaseNotificationManager();
//   await notificationManager.registerNotification();
//   var token = await notificationManager.deviceToken;
//   log(token ?? "n");
//   try {
//     await notificationManager.deviceToken;
//   } catch (ex) {
//     debugPrint(ex.toString());
//   }
// }
}
