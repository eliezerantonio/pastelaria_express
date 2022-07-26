import 'package:animate_do/animate_do.dart';
import 'package:pastelariaexpress/imports.dart';
import 'package:pastelariaexpress/models/cart/cart_manager.dart';

import '../../components/order/order_product_tile.dart';
import '../../models/order/order.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen(this.order);
  final Order order;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartManager>().clear();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            }),
        backgroundColor: Colors.white,
        title: const Text(
          "Pedido Confirmado",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
       decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink[300],
                        Colors.orange[300],
                      ],
                    ),
                    ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: FadeInDown(
                  child: const Text(
                    "Obrigado",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 25),
                    Pulse(
                      duration: const Duration(milliseconds: 2000),
                      delay: const Duration(milliseconds: 1500),
                      child: FadeInDown(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.pink[300],
                          size: 150,
                        ),
                      ),
                    ),
                    FadeInDown(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              widget.order.formattedId,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'KZ ${widget.order.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInDown(
                      child: Column(
                        children: widget.order.items.map((e) {
                          return OrderProductTile(e);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
