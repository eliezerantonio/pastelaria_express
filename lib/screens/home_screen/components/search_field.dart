import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product/product_manager.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductManager>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
        ),
        height: 45,
        width: double.infinity,
        child: TextField(
          onChanged: (text) {
            products.search = text;
          },
          decoration: const InputDecoration(
              hintText: "Pesquisar",
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }
}
