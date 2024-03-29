import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/clipboard.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_textfield.dart';
import '../../components/price_card.dart';
import '../../imports.dart';
import '../../models/cart/cart_manager.dart';
import '../../models/checkout_manager.dart';
import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String choiceUser = "";
  String reference = "";
  String obsController;
  bool isLoading = false;
  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool received = false;
  @override
  Widget build(BuildContext context) {
    final product = context.watch<CartManager>().items[0].product;

    final pastryshop = context
        .read<PastryshopManager>()
        .pastryshops
        .where((element) => element.adminId == product.adminId)
        .first;
    final user = context.watch<UserManager>().user;
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Pagamento',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.pink[300]),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Finalizando a compra aguarde...',
                      style: TextStyle(
                        color: Colors.pink[300],
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.pink[300]),
              );
            }
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink[300],
                        Colors.orange[300],
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100)),
                  ),
                  height: 232,
                  width: double.infinity,
                ),
                Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      BounceInRight(
                        duration: const Duration(milliseconds: 1000),
                        child: CreditCardWidget(
                          reference: reference,
                          onPressed: (s) {
                            setState(() {
                              choiceUser = s;
                            });
                          },
                        ),
                      ),
                      if (choiceUser == "IBAM") ...[
                        GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(pastryshop.ibam).then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: const Text("Copiado"),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(pastryshop.ibam ?? ""),
                              const Icon(Icons.copy),
                            ],
                          ),
                        ),
                        _imageFile == null
                            ? Image.asset("assets/img/transferir.png",
                                height: 100, width: 80)
                            : Image.file(
                                File(_imageFile.path),
                                height: 100,
                                width: 80,
                              ),
                        TextButton(
                          child: Text(_imageFile == null
                              ? "Carregar comprovativo"
                              : "Carregar outro comprovativo"),
                          onPressed: () async {
                            final XFile pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            setState(() {
                              _imageFile = File(pickedFile.path);
                            });
                          },
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          labelText: 'Especificar detalhes',
                          onSaved: (value) => obsController = value,
                          prefixIcon: const Icon(Icons.description,
                              color: Colors.white),
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text("Quero receber"),
                        value: received,
                        onChanged: (newValue) {
                          setState(() {
                            received = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                      PriceCard(
                        buttonText: 'Confirmar',
                        received: received,
                        onPressed: choiceUser != "IBAM" || _imageFile != null
                            ? () async {
                                if (choiceUser.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      content: const Text(
                                          "Selecione um metodo de pagamento"),
                                    ),
                                  );
                                  return;
                                }
                                formKey.currentState.save();
                                checkoutManager.checkout(
                                  user: user,
                                  img: _imageFile,
                                  pay: choiceUser,
                                  obs: obsController,
                                  onStockFail: (e) {
                                    Navigator.of(context).popUntil((route) =>
                                        route.settings.name == '/cart');
                                  },
                                  onSuccess: (order) {
                                    Navigator.of(context).popUntil((route) =>
                                        route.settings.name == '/home');
                                    Navigator.of(context).pushNamed(
                                        "/confirmation",
                                        arguments: order);
                                  },
                                );
                              }
                            : null,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

//Dialogo de pagamento

}
