import 'package:dash_pass_web/config/utils/get_rol_id_util.dart';
import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> roles = [
  "Super Administrador",
  "Administrador",
  "Conductor",
];

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 5),
    blurRadius: 5,
    blurStyle: BlurStyle.inner,
  ),
];

class CreateUserPage extends StatefulWidget {
  static const name = "/users-page/create-user";
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController carnetController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final descriptionTextStyle = GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    );

    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xffF4F4F4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
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
                                    "Crear usuario",
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
                    const SizedBox(height: 20),
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
                                    "Contraseña",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CreateUserTextField(
                                      title: "Contraseña",
                                      controller: passwordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "La contraseña es obligatoria.";
                                        }
                                        if (value.length < 8) {
                                          return "Debe tener al menos 8 caracteres.";
                                        }
                                        if (!RegExp(
                                                r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&])')
                                            .hasMatch(value)) {
                                          return "Debe incluir letras, números y caracteres especiales.";
                                        }
                                        return null;
                                      },
                                    ),
                                    CreateUserTextField(
                                      title: "Repetir contraseña",
                                      controller: confirmPasswordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value != passwordController.text) {
                                          return "Las contraseñas no coinciden.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'La contraseña debe contener:',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text('• Una combinación de letras (a-z)',
                                          style: descriptionTextStyle),
                                      const SizedBox(height: 7),
                                      Text('• Caracteres especiales',
                                          style: descriptionTextStyle),
                                      const SizedBox(height: 7),
                                      Text('• Mayúsculas y minúsculas',
                                          style: descriptionTextStyle),
                                      const SizedBox(height: 7),
                                      Text('• Números (0-9)',
                                          style: descriptionTextStyle),
                                      const SizedBox(height: 7),
                                      Text('• Mínimo de 8 caracteres',
                                          style: descriptionTextStyle),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                if (_formKey.currentState!.validate() &&
                                    selectedRole != null) {
                                  context.read<UsersCubit>().addUser(
                                        carnet:
                                            int.parse(carnetController.text),
                                        email: emailController.text,
                                        rolId: getRolIdUtil(selectedRole ?? ""),
                                        name: nameController.text,
                                        password: passwordController.text,
                                        phone: int.parse(phoneController.text),
                                      );
                                  context.go(UsersPage.name);
                                }
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFF1C3C63),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class CreateUserTextField extends StatelessWidget {
  final String title;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  String? Function(String?)? validator;
  CreateUserTextField({
    super.key,
    required this.title,
    this.hintText,
    this.obscureText = false,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF26374D),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            validator: validator,
            obscureText: obscureText,
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF26374D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF26374D)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleDropDown extends StatelessWidget {
  final String title;
  final String hintText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const RoleDropDown({
    super.key,
    required this.title,
    required this.hintText,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF26374D),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                hint: Text(
                  hintText,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isExpanded: true,
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF26374D),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF26374D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
