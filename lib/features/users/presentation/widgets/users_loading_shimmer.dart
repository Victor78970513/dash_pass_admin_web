import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UsersLoadingShimmer extends StatelessWidget {
  const UsersLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                Container(
                  height: 50,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ...List.generate(
              15,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
