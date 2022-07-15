import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../components/components.dart';
import '../../components/custom_drawer/empty_card.dart';
import '../../components/custom_icon_buttom.dart';
import '../../components/order/order_tile.dart';
import '../../models/admin/admin_orders_manager.dart';
import '../../models/order/order.dart';

class AdminOrdersScreen extends StatelessWidget {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Meus pedidoss"),
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;
          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: [
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Pedidos de ${ordersManager.userFilter.name}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                        CustomIconButtom(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  Expanded(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: const EmptyCard(
                        title: 'Nenhuma venda realizada!',
                        iconData: Icons.border_clear,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredOrders.length,
                      reverse: true,
                      itemBuilder: (_, index) {
                        return OrderTile(
                          order: filteredOrders[index],
                          showControls: true,
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 100)
              ],
            ),
            minHeight: 40,
            maxHeight: 440,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      "Filtros",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((status) {
                      return CheckboxListTile(
                          title: Text(Order.getStatusText(status)),
                          value: ordersManager.statusFilter.contains(status),
                          dense: true,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (v) {
                            ordersManager.setStatusFilter(
                                status: status, enabled: v);
                          });
                    }).toList(),
                  ),
                )
              ],
            ),
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
