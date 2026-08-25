import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context){
    return Skeletonizer(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const Bone.square(
                size: 70,
              ),
              title: const Text(
                'Product Name Here',
              ),
              subtitle: const Text('\$99.99'),
              trailing: const Text(
                '⭐ 4.5'
              ),
            ),
          );
        },
      ),
    );
    }
  }
