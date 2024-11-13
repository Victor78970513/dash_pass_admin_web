import 'package:dash_pass_web/features/auth/cubit/auth_cubit.dart';
import 'package:dash_pass_web/features/auth/presentation/widgets/auth_input.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  static const name = "/signin";
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSucess) {
            context.go(UsersPage.name);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Fondo con gradiente
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 210, 206, 246),
                ),
              ),
              Center(
                child: Container(
                  height: size.height * 0.7,
                  width: size.width * 0.4,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(42, 39, 98, 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        SvgPicture.asset(
                          "assets/logos/dash_pass.svg",
                          width: size.width * 0.1,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 20),

                        // Título
                        const Text(
                          "Sistema de Gestión de Peajes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtítulo
                        const Text(
                          "Inicie sesión con su cuenta administrativa",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Campos de texto
                        AuthInput(
                          title: "Correo Electrónico",
                          controller: emailCtrl,
                          hintText: "Ingrese su correo electrónico",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20),
                        AuthInput(
                          title: "Contraseña",
                          controller: passCtrl,
                          hintText: "Ingrese su contraseña",
                          obscureText: true,
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 30),

                        // Botón de inicio de sesión
                        GestureDetector(
                          onTap: () {
                            context.read<AuthCubit>().signIn(
                                email: emailCtrl.text.trim(),
                                password: passCtrl.text.trim());
                          },
                          child: Container(
                            width: 180,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(255, 210, 206, 246),
                            ),
                            child: state is AuthLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.black),
                                  )
                                : const Center(
                                    child: Text(
                                      "Ingresar",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
