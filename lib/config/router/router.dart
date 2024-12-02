import 'package:dash_pass_web/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dash_pass_web/features/home/presentation/pages/home_page.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/reports_menu.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/graphics_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/create_toll_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/edit_toll_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/tolls_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/create_user_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/edit_user_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:dash_pass_web/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
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
              routes: [
                GoRoute(
                  path: CreateUserPage.name,
                  name: CreateUserPage.name,
                  builder: (context, state) => const CreateUserPage(),
                ),
                GoRoute(
                  path: EditUserPage.name,
                  name: EditUserPage.name,
                  builder: (context, state) {
                    final user = (state.extra as Map<String, dynamic>? ??
                        {})["user"] as UserAppModel;
                    return EditUserPage(user: user);
                  },
                ),
              ]),

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
            routes: [
              GoRoute(
                path: CreateTollPage.name,
                name: CreateTollPage.name,
                builder: (context, state) => const CreateTollPage(),
              ),
              GoRoute(
                path: EditTollPage.name,
                name: EditTollPage.name,
                builder: (context, state) {
                  final toll = (state.extra as Map<String, dynamic>? ??
                      {})["toll"] as TollModel;
                  return EditTollPage(toll: toll);
                },
              )
            ],
          ),

          // Subruta: Informes y Reportes
          GoRoute(
              path: ReportsMenu.name,
              name: ReportsMenu.name,
              builder: (context, state) => const ReportsMenu(),
              routes: [
                GoRoute(
                  path: GraphicsPage.name,
                  name: GraphicsPage.name,
                  builder: (context, state) => const GraphicsPage(),
                )
              ])
        ],
      ),
    ],
  );
}
