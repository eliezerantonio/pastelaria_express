import 'package:flutter/material.dart';
import 'package:pastelariaexpress/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../../components/custom_textfield.dart';
import '../../models/product/product.dart';
import '../../models/product/product_manager.dart';
import '../../models/user/user_manager.dart';
import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p, {Key key})
      : editing = p != null,
        product = p != null ? p.clone() : Product(),
        super(key: key);
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
              style: const TextStyle(color: Colors.black)),
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
                    CustomTextField(
                      initialValue: product.name,
                      validator: (name) {
                        if (name.length < 3) {
                          return 'Nome muito curto';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => product.name = name,
                      labelText: 'Nome',
                      prefixIcon: const Icon(Icons.cake, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      initialValue: !editing ? '' : product.price.toString(),
                      keyboardType: TextInputType.number,
                      validator: (price) {
                        if (price.length < 2) {
                          return 'Digite Preco valido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (price) => product.price = num.tryParse(price),
                      labelText: 'Preço',
                      prefixIcon: const Icon(Icons.attach_money_outlined,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      initialValue: product.description,
                      validator: (description) {
                        if (description.length < 2) {
                          return 'Digite descrição validq';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (description) =>
                          product.description = description,
                      labelText: 'Descrição',
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return Column(
                          children: [
                            SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SizedBox(
                                    height: 40,
                                    child: CustomButton(
                                      onPressed: !product.loading
                                          ? () async {
                                              if (formKey.currentState
                                                  .validate()) {
                                                formKey.currentState.save();
                                                //passando id do usuario logado e salvando o produto
                                                await product
                                                    .save(idUserManger.user.id);
                                                context
                                                    .read<ProductManager>()
                                                    .update(product);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          : null,
                                      text: 'Salvar',
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (product.loading)
                              CircularProgressIndicator(
                                backgroundColor: Colors.pink[300],
                              )
                          ],
                        );
                      },
                    ),
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
