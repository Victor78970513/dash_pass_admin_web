import 'package:dash_pass_web/features/home/presentation/widgets/navigator_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const name = '/home';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        const LateralNavigatorBar(),
        Expanded(child: child),
      ],
    ));
  }
}
