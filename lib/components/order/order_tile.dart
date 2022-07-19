import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order/order.dart';
import '../../models/user/user_manager.dart';
import '../show_alert.dart';
import 'cancel_order_dialog.dart';
import 'order_product_tile.dart';
import 'transfers_view.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({this.order, this.showControls = false});

  final bool showControls;
  final Order order;
//Metodo abrir teledonfe

  @override
  Widget build(BuildContext context) {
    print(order.transfer);
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    final int status = order.status.index;
    final userManager = context.watch<UserManager>();
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    final String formattedDate = formatter.format(order.date.toDate());

    void showError() {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text("Este dispositivo não possui esta função"),
          backgroundColor: Colors.red,
        ),
      );
    }

    void openPhone() async {
      if (await canLaunch('tel:${order.phone}')) {
        launch('tel:${order.phone}');
      } else {
        showError();
      }
    }

    Future.delayed(
      const Duration(minutes: 10),
      () {
        if (order.status == Status.accomplished &&
            userManager.user.id == order.userId) {
          order.cancel();

          showAlert(context, "Cancelado",
              "Pedido ${order.formattedId} cancelado, por motivo de não resposta do Restaurante. Volte a tentar!");
        }
      },
    );

    return FadeInRight(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Pedido n. ${order.formattedId}",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (order.pastryshop.name != null || order.pastryshop.name != "")
                Text(order.pastryshop.name ?? "Carregando...",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    )),
              const SizedBox(height: 9),
              Row(
                children: [
                  Text(
                    order.userName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${order.price?.toStringAsFixed(2)} KZ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.black)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Center(
                                child: Text(
                                  order.formattedId,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.obs != ""
                                        ? "Obs: ${order.obs ?? "Sem observação"}"
                                        : "Obs: Sem observação",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Pagamento por: ${order.pay ?? ""}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Entrega: ${order.deliveryPrice ?? ""} KZ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: order.items.map((e) {
                                      return OrderProductTile(e);
                                    }).toList(),
                                  ),
                                if(userManager.adminEnabled&& userManager.superEnabled)  Center(
                                    child: TextButton(
                                      child: const Text("Ligar para o cliente"),
                                      onPressed: openPhone,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text("Ver detalhes",
                        style:
                            TextStyle(color: Color.fromARGB(255, 41, 40, 40))),
                  ),
                  const Spacer(),
                  Text(
                    order.statusText,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: order.status == Status.canceled
                          ? const Color(0xFFF44336)
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (showControls && order.status != Status.canceled)
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (userManager.adminEnabled)
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => CancelOrderDialog(order));
                          },
                          textColor: Colors.red,
                          child: const Text("Cancelar"),
                        ),
                      FlatButton(
                        onPressed: () {
                          order.back();
                        },
                        child: const Text("Recuar"),
                      ),
                      FlatButton(
                        onPressed: () {
                          order.advance();
                        },
                        child: const Text("Avançar"),
                      ),
                    ],
                  ),
                )
              // else if (order.status == Status.accomplished &&
              //     !showControls &&
              //     !userManager.adminEnabled)
              //   FlatButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (_) => CancelOrderDialog(order),
              //       );
              //     },
              //     textColor: Colors.red,
              //     child: const Text("Cancelar"),
              //   ),

              ,
              if (order.transfer != "")
                TextButton(
                  child: const Text("Ver comprovativo"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TransferView(order.transfer)));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus,
      BuildContext context) {
    Color backColor;
    Widget child;
    if (status < thisStatus) {
      //ainda nao cheagamos
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: const TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      // chegamos
      backColor = Theme.of(context).primaryColor;
      child = Stack(
        alignment: Alignment.center,
        children: [
          child = Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Theme.of(context).colorScheme.secondary;
      child = const Icon(
        Icons.check,
        color: Colors.white,
      );
    }
    return Column(
      children: <Widget>[
        Text(subtitle),
        CircleAvatar(
          radius: 13,
          backgroundColor: backColor,
          child: child,
        ),
      ],
    );
  }
}
