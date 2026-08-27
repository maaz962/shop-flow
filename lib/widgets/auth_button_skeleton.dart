import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthButtonSkeleton extends StatelessWidget {
  const AuthButtonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Bone.button(
        width: double.infinity,
        height: 50,
      ),
    );
  }
}