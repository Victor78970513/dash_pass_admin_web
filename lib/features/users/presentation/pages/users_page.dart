import 'package:dash_pass_web/features/users/presentation/widgets/edit_user_widget.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle columnStyle = GoogleFonts.poppins(
      color: Colors.indigo,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: const Color.fromRGBO(244, 243, 253, 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 32,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Listado de usuarios",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(42, 39, 98, 1)),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingresa el nombre del usuario",
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.search_sharp,
                              color: Color.fromRGBO(42, 39, 98, 1),
                              size: 35,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 32,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("usuarios")
                      .where('activo', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No hay usuarios disponibles."),
                      );
                    }

                    final users = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return UserAppModel.fromMap(data);
                    }).where((user) {
                      // Filtrar por el nombre
                      return user.name.toLowerCase().contains(searchQuery);
                    }).toList();

                    if (users.isEmpty) {
                      return const Center(
                        child: Text("No se encontraron usuarios."),
                      );
                    }

                    return DataTable(
                      headingRowHeight: 100.0,
                      horizontalMargin: 50.0,
                      // ignore: deprecated_member_use
                      dataRowHeight: 150.0,
                      dataTextStyle: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      columns: [
                        DataColumn(
                          label: Center(
                            child: Text("Foto de perfil", style: columnStyle),
                          ),
                        ),
                        DataColumn(
                            label: Center(
                                child: Text("Nombre de Usuario",
                                    style: columnStyle))),
                        DataColumn(
                            label: Center(
                                child: Text("Correo electronico",
                                    style: columnStyle))),
                        DataColumn(
                            label: Center(
                                child: Text("Saldo", style: columnStyle))),
                        DataColumn(
                            label: Center(
                                child: Text("Carnet de Identidad",
                                    style: columnStyle))),
                        DataColumn(
                            label: Center(
                                child:
                                    Text("Usuario desde", style: columnStyle))),
                        const DataColumn(
                            label: Text(
                          "",
                        )),
                      ],
                      rows: users.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(
                              CircleAvatar(
                                backgroundImage: user
                                        .profilePictureUrl.isNotEmpty
                                    ? NetworkImage(user.profilePictureUrl)
                                        as ImageProvider
                                    : const AssetImage(
                                        "assets/images/no_profile_image.jpg"),
                                radius: 50,
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  user.name,
                                ),
                              ),
                            ),
                            DataCell(Center(
                              child: Text(user.email),
                            )),
                            DataCell(Center(
                                child: Text(
                                    "Bs. ${user.saldo.toStringAsFixed(2)}"))),
                            DataCell(
                                Center(child: Text("${user.carnetIdentidad}"))),
                            DataCell(Center(
                              child: Text(
                                  "${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}"),
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EditUserModal(
                                          userId: user.uid,
                                          initialName: user.name,
                                          initialSaldo: user.saldo,
                                          initialCarnet: user.carnetIdentidad,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
