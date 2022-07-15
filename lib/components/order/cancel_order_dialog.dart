import 'package:flutter/material.dart';

import '../../models/order/order.dart';


class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Cencelar ${order.formattedId} ?"),
      content: const Text("Esta acção não poderá ser desfeita!"),
      actions: [
        FlatButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text("Cancelar Pedido"),
        )
      ],
    );
  }
}
