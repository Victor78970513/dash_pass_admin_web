import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  static const name = '/reports-page';
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(244, 243, 253, 1),
      child: const Text("Reports Page"),
    );
  }
}
