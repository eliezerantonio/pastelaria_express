import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_icon_buttom.dart';
import '../../../models/cart/cart_product.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.cartProduct);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    final image = cartProduct.product.images.first;
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed('/product', arguments: cartProduct.product);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset("images/no-image"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cartProduct.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Consumer<CartProduct>(builder: (_, cartProduct, __) {
                            return Text(
                              "Kz ${cartProduct.unitPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          
                        })
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) {
                    return Column(
                      children: [
                        CustomIconButtom(
                          iconData: Icons.add,
                          color: Theme.of(context).primaryColor,
                          onTap: () {
                            cartProduct.increment();
                          },
                        ),
                        Text(
                          "${cartProduct.quantity}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        CustomIconButtom(
                          iconData: Icons.remove,
                          color: cartProduct.quantity > 1
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.red,
                          onTap: () {
                            cartProduct.decrement();
                          },
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
