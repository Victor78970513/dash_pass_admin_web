import 'package:dash_pass_web/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dash_pass_web/features/home/presentation/pages/home_page.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/reports_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/tolls_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:dash_pass_web/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:go_router/go_router.dart';

class DashPass {
  static GoRouter goRouter = GoRouter(
    initialLocation: SignInPage.name,
    routes: [
      // LOGIN ROUTE
      GoRoute(
        path: SignInPage.name,
        name: SignInPage.name,
        builder: (context, state) {
          return const SignInPage();
        },
      ),

      // HOME ROUTE
      ShellRoute(
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          // Subruta: Usuarios
          GoRoute(
            path: UsersPage.name,
            name: UsersPage.name,
            builder: (context, state) => const UsersPage(),
          ),

          // Subruta: Flujo vehicular
          GoRoute(
            path: VehiclesPage.name,
            name: VehiclesPage.name,
            builder: (context, state) => const VehiclesPage(),
          ),

          // Subruta: Peajes
          GoRoute(
            path: TollsPage.name,
            name: TollsPage.name,
            builder: (context, state) => const TollsPage(),
          ),

          // Subruta: Informes y Reportes
          GoRoute(
            path: ReportsPage.name,
            name: ReportsPage.name,
            builder: (context, state) => const ReportsPage(),
          )
        ],
      ),
    ],
  );
}
