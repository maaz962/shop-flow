import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context){
    return Skeletonizer(
      child: LayoutBuilder(
        builder: (context, constraints){
          int columns;

          if(constraints.maxWidth >= 1200){
            columns = 5;
          } else if(constraints.maxWidth >= 900){
            columns = 4;
          } else if(constraints.maxWidth >= 600) {
            columns = 3;
          } else {
            columns = 2;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),

            itemBuilder: (context, index){
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Bone(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    Expanded(
                      flex: 4,
                      child: Padding(padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Bone.text( words:3),
                          const SizedBox(height: 6),

                          //Price
                          const Bone.text(width: 80),

                          // Original Price
                          const Bone.text(width: 60,),

                          const SizedBox(height: 5,),

                          // Rating + Delete
                          Row(
                            children: [
                              const Bone.square(
                                size: 16,
                              ),
                              const SizedBox(width: 4,),

                              const Bone.text(width: 25,),

                              const Spacer(),

                              const Bone.square(
                                size: 21,
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Free Shipping
                          Row(
                            children: [
                              const Bone.square(size: 16,),
                              const SizedBox(width: 4,),
                              const Bone.text(
                                width: 85,
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
    }
  }
