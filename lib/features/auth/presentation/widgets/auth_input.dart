import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? icon;

  const AuthInput({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  GoogleFonts.poppins(color: Colors.white.withOpacity(0.5)),
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.white.withOpacity(0.7))
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.2)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.1, size.width, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    final path2 = Path()
      ..moveTo(size.width, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.9,
          size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.7, 0, size.height * 0.9)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
