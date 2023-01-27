

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/remote/auth_api.dart';
import '../data/remote/home_api.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/home_repository.dart';
import '../viewmodels/views/home_view_model.dart';
import '../viewmodels/views/login_viewmodel.dart';

List<SingleChildWidget> providers = [
  //auth injection
  ...independentAuthInjection,
  ...dependentAuthService,
  ...dependentAuthModel,
  // ...loginViewModel,

  //Home Injection
  ...indepenedentHomeInjection,
  ...dependentHomeRepository,
  // ...homeViewModel
];

//Auth
List<SingleChildWidget> independentAuthInjection = [Provider.value(value: AuthApi())];
List<SingleChildWidget> dependentAuthService = [
  ProxyProvider<AuthApi, AuthRepository>(
    update: (context, api, repo) => AuthRepository(api: api),
  )
];
List<SingleChildWidget> dependentAuthModel = [
  ProxyProvider<AuthRepository, LoginViewModel>(
    update: (context, authRepository, previous) => LoginViewModel(authRepository: authRepository),
  )
];
List<SingleChildWidget> loginViewModel = [
  ProxyProvider0(update: (context, value) => LoginViewModel(authRepository: Provider.of(context)),)
];

//Home
List<SingleChildWidget> indepenedentHomeInjection = [Provider.value(value: HomeApi())];
List<SingleChildWidget> dependentHomeRepository = [
  ProxyProvider<HomeApi, HomeRepository>(update: (context, value, previous) => HomeRepository(api: value),)];
List<SingleChildWidget> homeViewModel = [
  ProxyProvider0(update: (context, value) => HomeViewModel(repo: Provider.of(context)),)
]; 
