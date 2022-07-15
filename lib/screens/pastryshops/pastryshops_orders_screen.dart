import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_drawer/empty_card.dart';
import '../../components/custom_drawer/login_card.dart';
import '../../components/order/order_tile.dart';
import '../../models/order/orders_manager.dart';
import '../../models/pastryshop/pastryshop.dart';

class PastryshopsOrdersScreen extends StatefulWidget {
  PastryshopsOrdersScreen(this.pastryshop);
  Pastryshop pastryshop;

  @override
  State<PastryshopsOrdersScreen> createState() =>
      _PastryshopsOrdersScreenState();
}

class _PastryshopsOrdersScreenState extends State<PastryshopsOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersManager>().getOrders(widget.pastryshop.adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInLeftBig(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      accumulated(ordersManager.totalAccumulated),
                      const Text("5%")
                    ],
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  FadeInRightBig(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      accumulated(ordersManager.totalAccumulatedPastryshot),
                      const Text("95%")
                    ],
                  )),
                ],
              ),
              Expanded(
                child: ListView.builder(
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container accumulated(num totalAccumulated) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.pink[300]),
          borderRadius: BorderRadius.circular(30)),
      child: Text("${totalAccumulated.toStringAsFixed(2)} KZ"),
    );
  }
}
