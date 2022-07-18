import 'package:flutter/material.dart';
import 'package:pastelariaexpress/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../models/cart/cart_manager.dart';

class PriceCard extends StatelessWidget {
  PriceCard({
    this.buttonText,
    this.onPressed,
    this.timeDelivery,
    this.received = false,
  });

  final String buttonText;
  final VoidCallback onPressed;
  final String timeDelivery;
  bool received;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productPrice = cartManager.productsPrice;
    num totalPrice = cartManager.totalPrice+=received?1000:0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text(" Kz ${productPrice.toStringAsFixed(2)}"),
              ],
            ),
            const SizedBox(height: 10),
            if (received) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Taxa de Entrega",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text("Kz 1000"),
                ],
              ),
            ],
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  " Kz  ${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                height: 40,
                child: CustomButton(
                  onPressed: onPressed,
                  text: buttonText,
                ),
              ),
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                cartManager.clear();
              },
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
