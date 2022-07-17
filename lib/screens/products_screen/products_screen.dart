import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_manager.dart';
import '../../models/user/user_manager.dart';
import 'components/product_list_tile.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({@required this.pastryshop});

  var pastryshop = Pastryshop();

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String storeReserveId = '';

  @override
  void initState() {
    super.initState();
    if (!context.read<UserManager>().adminEnabled) {
      context.read<ProductManager>().allProducts.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    //recebendo dados
    return ChangeNotifierProvider.value(
      //recebendo os dados passados apartir da te

      value: widget.pastryshop,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              floating: true,
              elevation: 8,
              excludeHeaderSemantics: true,
              backgroundColor: Colors.white,
              actions: [
                Consumer<ProductManager>(
                  builder: (_, productManager, __) {
                    if (productManager.search.isEmpty) {
                      //se  nao pesquisei nada mostro lut
                      return Row(
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                              onPressed: () async {
                                final search = await showDialog<String>(
                                    context: context,
                                    builder: (_) =>
                                        SearchDialog(productManager.search));
                                if (search != null) {
                                  productManager.search = search;
                                }
                              },
                            ),
                          )
                        ],
                      );
                    } else {
                      return IconButton(
                        //se pesquisei mostro x
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () async {
                          productManager.search = '';
                        },
                      );
                    }
                  },
                ),
                Consumer<UserManager>(
                  builder: (_, userManager, __) {
                    if (userManager.adminEnabled) {
                      return Container(
                        margin: const EdgeInsets.all(4.7),
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(13)),
                        child: IconButton(
                          icon: const Icon(Icons.add,
                              size: 25, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/edit_product");
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(7),
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
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.pastryshop != null
                            ? widget.pastryshop.name
                            : "Sem nome",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Hero(
                    tag: widget.pastryshop.id ?? "",
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.pastryshop != null
                          ? widget.pastryshop.image
                          : 'Null',
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Consumer2<ProductManager, UserManager>(
                  builder: (_, productManager, userManager, __) {
                    final filteredProducts = productManager.allProducts;
                    if (!userManager.adminEnabled &&
                        widget.pastryshop.adminId != null) {
                      productManager.loadAllProducts(
                          adminId: widget.pastryshop.adminId);
                      return Stack(
                        children: [
                          //cliente

                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredProducts.length,
                            itemBuilder: (_, index) {
                              return ProductLisTile(
                                filteredProducts[index],
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                          ),
                        ],
                      );
                    } else {
                      ///admin

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (_, index) {
                          return ProductLisTile(
                            filteredProducts[index],
                          );
                        },
                      );
                    }
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
