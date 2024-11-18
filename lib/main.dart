import 'package:dash_pass_web/config/router/router.dart';
import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/features/auth/cubit/auth_cubit.dart';
import 'package:dash_pass_web/features/home/cubit/navigation_cubit.dart';
import 'package:dash_pass_web/features/reports/presentation/cubit/pases_cubit.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/cubit/users_cubit.dart';
import 'package:dash_pass_web/features/vehicles/presentation/cubit/vehicles_cubit.dart';
import 'package:dash_pass_web/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = Preferences();
  await prefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => UsersCubit()),
        BlocProvider(create: (context) => TollsCubit()),
        BlocProvider(create: (context) => PasesCubit()),
        BlocProvider(create: (context) => VehiclesCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      routerConfig: DashPass.goRouter,
      builder: (context, child) {
        return MainLayoutPage(child: child!);
      },
    );
  }
}

class MainLayoutPage extends StatelessWidget {
  final Widget child;
  const MainLayoutPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
