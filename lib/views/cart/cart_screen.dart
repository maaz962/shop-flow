import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget{
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),

      body: Column(
        children: [
          Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_cart_outlined,
                    size: 80,),
                    SizedBox(height: 16,),
                    Text(
                      'Your cart is Empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      'Add products to your cart',
                    ),
                  ],
                ),
              ),
          ),

          // Checkout section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Subtotal'),
                    Text('\$0.00'),
                  ],
                ),

                const SizedBox(height: 12,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: null,
                      child: const Text(
                        'Proceed to checkout',
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}