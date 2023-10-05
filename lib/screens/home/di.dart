import 'package:get_it/get_it.dart';
import 'package:go_fleet/screens/home/services/api_service.dart';

import '../utilis/config/app_configs.dart';
import '../utilis/network/network_request.dart';
import 'cubit/profile_cubit.dart';

void setupProfileService(GetIt ioc) {
  ioc.registerSingleton<ProfileCubit>(
    ProfileCubit(
      apiService: ProfileApiService(
        http: HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true),
      ),
    ),
  );
}
