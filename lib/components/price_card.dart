import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart/cart_manager.dart';

class PriceCard extends StatelessWidget {
  const PriceCard(
      {this.buttonText, this.onPressed, this.timeDelivery, this.userChoice});

  final String buttonText;
  final VoidCallback onPressed;
  final String timeDelivery;
  final String userChoice;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productPrice = cartManager.productsPrice;
    final totalPrice = cartManager.totalPrice;
    final serviceCharge = cartManager.serviceCharge;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Taxa",
                  style: TextStyle(color: Colors.black),
                ),
                Text(serviceCharge.toString()),
              ],
            ),
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
                child: RaisedButton(
                  onPressed: onPressed,
                  disabledColor:
                      Theme.of(context).colorScheme.secondary.withAlpha(200),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(buttonText),
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