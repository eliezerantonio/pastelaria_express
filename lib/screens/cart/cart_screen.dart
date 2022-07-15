import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_drawer/empty_card.dart';
import '../../components/custom_drawer/login_card.dart';
import '../../components/price_card.dart';
import '../../models/cart/cart_manager.dart';
import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<CartManager>().onItemUpdate();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Carrinho",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          //se o usuario nao esta logado mostrar caixa par alogar
          if (cartManager.user == null) {
            return LoginCard();
          }
          if (cartManager.items.isEmpty) {
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }
          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar',
                onPressed:  () {
                        Navigator.of(context).pushNamed(
                          '/checkout',
                          arguments: cartManager.items[0].product.adminId,
                        );
                      }
                   
              ),
            ],
          );
        },
      ),
    );
  }
}
