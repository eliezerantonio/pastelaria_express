import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pastelariaexpress/models/product/product.dart';
import 'package:provider/provider.dart';

import '../../../models/product/product_manager.dart';

class CarouselSliderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductManager>().filteredProducts;

    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: products
          .map(
            (e) => newMethod(e, context),
          )
          .toList(),
    );
  }

  Widget newMethod(Product e, BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("/product", arguments: e);
        },
        child: Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(left: 3, right: 9),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: e.images[0],
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );
}
