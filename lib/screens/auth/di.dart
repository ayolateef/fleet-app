import 'package:get_it/get_it.dart';
import 'package:go_fleet/screens/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:go_fleet/screens/auth/sign_in/service/api_service.dart';
import 'package:go_fleet/screens/auth/signup/cubits/auth/auth_cubit.dart';
import 'package:go_fleet/screens/auth/signup/services/auth_service.dart';

import '../utilis/config/app_configs.dart';
import '../utilis/network/network_request.dart';

void setupAuthServices(GetIt ioc) {
  ioc.registerSingleton<AuthCubit>(
    AuthCubit(
      authService: AuthService(
        httpService:
            HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true),
      ),
    ),
  );

  ioc.registerSingleton<SignInCubit>(
    SignInCubit(
      apiService: SignInApiService(
        http: HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true),
      ),
    ),
  );
}
