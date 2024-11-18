import 'package:dash_pass_web/features/users/presentation/cubit/users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/add_user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:dash_pass_web/features/users/presentation/widgets/edit_user_widget.dart';

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Listado de usuarios",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  "$cantUsers ${cantUsers > 1 ? "usuarios" : "usuario"}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Buscar usuario por nombre",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AddUserModal();
                        },
                      );
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3C63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Agregar usuario",
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                switch (state) {
                  case UsersInitial():
                  case UsersLoading():
                    return const Center(child: CircularProgressIndicator());

                  case UsersLoaded():
                    final users = state.users.where((user) {
                      return user.name.toLowerCase().contains(searchQuery);
                    }).toList();
                    return LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              // ignore: deprecated_member_use
                              dataRowHeight: 90,
                              headingTextStyle: GoogleFonts.poppins(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              dataTextStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              columns: _buildColumns(),
                              rows: _buildRows(users, context),
                            ),
                          ),
                        ),
                      );
                    });

                  case UsersError(message: final message):
                    return Center(
                      child: Text(message),
                    );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

List<DataColumn> _buildColumns() {
  return const [
    DataColumn(label: Expanded(child: Center(child: Text("Foto de perfil")))),
    DataColumn(label: Expanded(child: Center(child: Text("Nombre")))),
    DataColumn(label: Expanded(child: Center(child: Text("Correo")))),
    DataColumn(label: Expanded(child: Center(child: Text("Saldo")))),
    DataColumn(label: Expanded(child: Center(child: Text("Carnet")))),
    DataColumn(label: Expanded(child: Center(child: Text("Usuario desde")))),
    DataColumn(label: Expanded(child: Center(child: Text("Acciones")))),
  ];
}

List<DataRow> _buildRows(List<UserAppModel> users, BuildContext context) {
  return List.generate(users.length, (index) {
    final user = users[index];
    return DataRow(
      cells: [
        DataCell(Center(
          child: CircleAvatar(
            backgroundImage: user.profilePicture.isNotEmpty
                ? NetworkImage(user.profilePicture)
                : const AssetImage(
                    "assets/images/no_profile_image.jpg",
                  ) as ImageProvider,
            radius: 35,
          ),
        )),
        DataCell(
          Center(
            child: Text(user.name),
          ),
        ),
        DataCell(
          Center(
            child: Text(user.email),
          ),
        ),
        DataCell(
          Center(
            child: Text("Bs. ${user.saldo.toStringAsFixed(2)}"),
          ),
        ),
        DataCell(
          Center(
            child: Text(user.carnet.toString()),
          ),
        ),
        DataCell(
          Center(
            child: Text(
                "${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}"),
          ),
        ),
        DataCell(
          Center(
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditUserModal(
                      userId: user.uid,
                      initialName: user.name,
                      initialSaldo: user.saldo,
                      initialCarnet: user.carnet,
                      initialEmail: user.email,
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit, color: Colors.indigo),
            ),
          ),
        ),
      ],
    );
  });
}
