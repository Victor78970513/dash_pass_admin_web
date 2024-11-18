import 'package:dash_pass_web/features/auth/cubit/auth_cubit.dart';
import 'package:dash_pass_web/features/auth/presentation/widgets/auth_input.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  static const name = "/signin";
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool isHuman = false; // Estado para el checkbox

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
              // Background with gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1C3C63),
                      Color(0xFF4A90E2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Animated background shapes
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundShapesPainter(),
                ),
              ),
              Center(
                child: Container(
                  height: size.height * 0.75,
                  width: size.width * 0.35,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                          width: size.width * 0.08,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),

                        // Title
                        Text(
                          "Sistema de Gestión de Peajes",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Subtitle
                        Text(
                          "Inicie sesión con su cuenta administrativa",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Text fields
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

                        // Checkbox and "No soy un robot"
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isHuman,
                              onChanged: (value) {
                                setState(() {
                                  isHuman = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF4A90E2),
                            ),
                            Text(
                              "No soy un robot",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Login button
                        ElevatedButton(
                          onPressed: isHuman
                              ? () {
                                  context.read<AuthCubit>().signIn(
                                      email: emailCtrl.text.trim(),
                                      password: passCtrl.text.trim());
                                }
                              : null, // Deshabilitar si no está marcado
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Ingresar",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
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
