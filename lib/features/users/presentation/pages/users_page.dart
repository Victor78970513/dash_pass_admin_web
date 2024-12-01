import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/pages/create_user_page.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/filter_users_modal.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/user_info_header.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/user_info_widget.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/users_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 5),
    blurRadius: 5,
    blurStyle: BlurStyle.inner,
  )
];

class UsersPage extends StatefulWidget {
  static const name = "/users-page";
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchUsers();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cantUsers = context.watch<UsersCubit>().usersQuantity;
    return Container(
      color: const Color(0xffF4F4F4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Listado de Usuarios",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: boxShadow,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Color.fromARGB(255, 176, 181, 185)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              style: GoogleFonts.poppins(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: "Buscar usuario por nombre",
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  UsersPageActionButton(
                    title: "Crear usuario",
                    icon: Icons.person_add_alt_1_outlined,
                    onTap: () => context.go(CreateUserPage.name),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                switch (state) {
                  case UsersInitial():
                  case UsersLoading():
                    return const UsersLoadingShimmer();
                  case UsersLoaded():
                    final users = state.users
                        .where((user) =>
                            user.name.toLowerCase().contains(searchQuery))
                        .toList();
                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Mostrando $cantUsers usuarios",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const FilterUsersModal();
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        child: Row(
                                          children: [
                                            const Icon(FontAwesomeIcons.filter),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Filtrar por",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const UserInfoHeader(),
                            ...List.generate(users.length + 1, (index) {
                              if (index != users.length) {
                                final user = users[index];
                                return UserInfoWidget(user: user);
                              } else {
                                return const SizedBox(height: 40);
                              }
                            })
                          ],
                        ),
                      ),
                    );
                  case UsersError(message: final message):
                    return Center(
                      child: Text(message),
                    );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersPageActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const UsersPageActionButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1C3C63),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
