import 'package:dash_pass_web/config/utils/get_rol_id_util.dart';
import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/pages/create_user_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 5),
    blurRadius: 5,
    blurStyle: BlurStyle.inner,
  ),
];

class EditUserPage extends StatefulWidget {
  static const name = "edit-user";

  final UserAppModel user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController carnetController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedRole;
  @override
  void initState() {
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    carnetController.text = widget.user.carnet.toString();
    phoneController.text = widget.user.phone.toString();
    selectedRole = getRolNameById(widget.user.rolId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xffF4F4F4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: boxShadow,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Editar usuario",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    "Todos los campos son obligatorios",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CreateUserTextField(
                              title: "Nombre",
                              controller: nameController,
                              hintText: "Ingresa el nombre",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "El nombre es obligatorio.";
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: CreateUserTextField(
                              title: "Correo",
                              controller: emailController,
                              hintText: "Ingresa el correo",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "El correo es obligatorio.";
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return "Ingresa un correo válido.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CreateUserTextField(
                              title: "Carnet de Identidad",
                              controller: carnetController,
                              hintText: "Ingresa el carnet de identidad",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "El carnet de identidad es obligatorio.";
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: CreateUserTextField(
                              title: "Teléfono",
                              controller: phoneController,
                              hintText: "Ingresa el teléfono",
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "El teléfono es obligatorio.";
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return "Ingresa un número de teléfono válido.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      RoleDropDown(
                        title: 'Rol',
                        hintText: 'Selecciona un rol',
                        selectedValue: selectedRole,
                        items: roles,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                      if (selectedRole == null)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "El rol es obligatorio.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: boxShadow,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => context.go(UsersPage.name),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Cancelar",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () async {
                            context.read<UsersCubit>().updateUser(
                                  nombre: nameController.text,
                                  correo: emailController.text,
                                  uid: widget.user.uid,
                                  carnet: int.parse(carnetController.text),
                                  phone: int.parse(phoneController.text),
                                  rolId: getRolIdUtil(selectedRole ?? ""),
                                );
                            context.go(UsersPage.name);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color(0xFF1C3C63),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: state is UsersLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Guardar",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
