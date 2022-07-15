import 'package:flutter/material.dart';
import 'package:pastelariaexpress/components/components.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';
import 'package:provider/provider.dart';

import '../../models/pastryshop/pastryshop_mananger.dart';
import '../../models/user/user_manager.dart';
import 'components/images_form.dart';

class ProfilePastryshopScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Pastryshop pastryshop = Pastryshop();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final idUserManger = UserManager();

    return ChangeNotifierProvider.value(
      value: pastryshop,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              const Text('Criar Perfil', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: const [
            // if (editing)
            //   IconButton(
            //     icon: const Icon(Icons.delete),
            //     onPressed: () {
            //       context.read<Pastryshop>().delete(product);
            //       Navigator.of(context).pop();
            //     },
            //   )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImagesForm(pastryshop.newImages),
              ),
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
                    CustomTextField(
                      validator: (name) {
                        if (name.length < 3) {
                          return 'Nome muito curto';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => pastryshop.name = name,
                      labelText: 'Nome',
                      prefixIcon: const Icon(Icons.shop, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      validator: (desc) {
                        if (desc.length < 3) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => pastryshop.description = desc,
                      labelText: 'Descrição',
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      validator: (desc) {
                        if (desc.length < 13) return 'Ibam';
                        return null;
                      },
                      onSaved: (desc) => pastryshop.description = desc,
                      labelText: 'Descrição',
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Pastryshop>(
                      builder: (_, pastryshop, __) {
                        return SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: SizedBox(
                              height: 40,
                              child: CustomButton(
                                onPressed: !pastryshop.loading
                                    ? () async {
                                        formKey.currentState.save();
                                        if (formKey.currentState.validate()) {
                                          //passando id do usuario logado e salvando o produto
                                          await pastryshop
                                              .save(idUserManger.user.id);
                                          context
                                              .read<PastryshopManager>()
                                              .update(pastryshop);
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    : null,
                                text: 'Salvar',
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
