import 'package:flutter/material.dart';

class VehiclesPage extends StatelessWidget {
  static const name = '/vehicles-page';
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(244, 243, 253, 1),
      child: const Text("vehicles Page"),
    );
  }
}
