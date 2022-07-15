import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product/product.dart';
import '../../models/product/product_manager.dart';
import '../../models/user/user_manager.dart';
import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p, {Key key})
      : editing = p != null,
        product = p != null ? p.clone() : Product(), super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Product product;
  final bool editing;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final idUserManger = UserManager();

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(editing ? "Editar Produto" : 'Criar Produto',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Titulo',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name.length < 3) {
                          return 'Título muito curto';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Preço',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: !editing ? '' : product.price.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Preço',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name.length < 2) {
                          return 'Digite Preco valido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (price) => product.price = num.tryParse(price),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Stock',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                   
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      validator: (desc) {
                        if (desc.length < 3) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 40,
                              child: RaisedButton(
                                onPressed: !product.loading
                                    ? () async {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          //passando id do usuario logado e salvando o produto
                                          await product.save(idUserManger.user.id);
                                          context
                                              .read<ProductManager>()
                                              .update(product);
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    : null,
                                textColor: Colors.white,
                                color: primaryColor,
                                disabledColor: primaryColor.withAlpha(100),
                                child: product.loading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )
                                    : const Text(
                                        "Salvar",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
