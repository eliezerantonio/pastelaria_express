import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../components/custom_drawer/empty_card.dart';
import '../../components/custom_drawer/login_card.dart';
import '../../components/order/order_tile.dart';
import '../../models/order/orders_manager.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Pedidos",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.user == null) {
            return LoginCard();
          }
          if (ordersManager.orders.isEmpty) {
            return const EmptyCard(
              title: 'Nenhuma compra encontrada',
              iconData: Icons.border_clear,
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: ordersManager.orders.length,
            itemBuilder: (_context, index) {
              if (ordersManager.orders[index].adminId == null) {
                return const CircularProgressIndicator.adaptive();
              } else {
                return OrderTile(
                  order: ordersManager.orders.reversed.toList()[index],
                );
              }
            },
          );
        },
      ),
    );
  }
}
