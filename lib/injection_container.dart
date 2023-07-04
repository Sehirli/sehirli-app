import 'package:get_it/get_it.dart';
import 'package:sehirli/bloc/register/register_bloc.dart';

import 'package:sehirli/bloc/username/username_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => UsernameBloc());
  sl.registerFactory(() => RegisterBloc());
}