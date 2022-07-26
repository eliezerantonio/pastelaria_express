import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pastelariaexpress/components/custom_button.dart';

import '../../imports.dart';
import '../../models/cart/cart_manager.dart';
import '../../models/product/product.dart';
import '../loginscreen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final pastryshop = context
        .read<PastryshopManager>()
        .pastryshops
        .where((element) => element.adminId == product.adminId);
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CarouselSlider(
                items: product.images.map((url) {
                  return Hero(
                    tag: product.id,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 300,
                  autoPlay: false,
                  viewportFraction: 1,
                ),
              ),
              Positioned(
                right: 2,
                child: Consumer<UserManager>(
                  builder: (_, userManager, __) {
                    if (userManager.adminEnabled && !product.deleted) {
                      return Container(
                        margin: const EdgeInsets.all(7),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              "/edit_product",
                              arguments: product,
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Positioned(
                left: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 280),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 55,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200]),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Pastelaria: " + pastryshop.first.name,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                          const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              '${product.price != null ? product.price.toStringAsFixed(2) : 0.0}KZ',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (product.deleted)
                          const Text(
                            "Este produto não está mais disponivel!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Consumer2<UserManager, Product>(
            builder: (_, userManager, product, __) {
          if (!userManager.superEnabled &&
              !userManager.adminEnabled &&
              userManager.isLogged) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (userManager.isLogged) {
                            final cart = context.read<CartManager>();

                            if (cart.items.isEmpty) {
                              addProduct(cart, product, context);
                              return;
                            }
                            final productCart = cart.items.first;
                            final isIquals =
                                product.adminId == productCart.userId;
                            if (isIquals) {
                              addProduct(cart, product, context);
                            } else {
                              cart.clear();
                              addProduct(cart, product, context);
                            }
                          } else {}
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                            color: Colors.white,
                          ),
                          child: const Text("Enviar ao Carrinho",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/cart');
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.pink[300],
                              Colors.orange[300],
                            ]),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Ver carrinho",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return !userManager.superEnabled &&
                    !userManager.adminEnabled &&
                    !userManager.isLogged
                ? Container(
                    height: 47,
                    margin: const EdgeInsets.all(10),
                    child: CustomButton(
                      text: 'Faça login para comprar',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                    ),
                  )
                : Container();
          }
        }),
      ),
    );
  }
}

void addProduct(CartManager cart, Product product, BuildContext context) {
  cart.addToCart(product);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "Adicionado ao carrinho",
        style: TextStyle(fontSize: 17),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
