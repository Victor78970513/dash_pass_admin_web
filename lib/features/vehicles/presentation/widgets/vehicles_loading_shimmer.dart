import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VehiclesLoadingShimmer extends StatelessWidget {
  const VehiclesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
