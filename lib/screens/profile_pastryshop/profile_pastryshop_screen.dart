import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pastelariaexpress/components/components.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';
import 'package:provider/provider.dart';

import '../../models/pastryshop/pastryshop_mananger.dart';
import '../../models/user/user_manager.dart';

class ProfilePastryshopScreen extends StatefulWidget {
  @override
  State<ProfilePastryshopScreen> createState() =>
      _ProfilePastryshopScreenState();
}

class _ProfilePastryshopScreenState extends State<ProfilePastryshopScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final idUserManger = UserManager();
    final pastryshops = context.watch<PastryshopManager>()?.pastryshops;
    final pastryshop = pastryshops.isNotEmpty
        ? context.watch<PastryshopManager>()?.pastryshops[0]
        : Pastryshop();

    return ChangeNotifierProvider.value(
      value: pastryshop,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              const Text('Criar Perfil', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: const [],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              if (_imageFile == null && pastryshop.image == null ||
                  pastryshop.image == "")
                Material(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    child: IconButton(
                      icon: const Icon(Icons.cake),
                      onPressed: () {
                        onImageSelected();
                      },
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                    ),
                  ),
                ),
              _imageFile?.path != null
                  ? GestureDetector(
                      onTap: () {
                        onImageSelected();
                        pastryshop.image = null;
                        setState(() {});
                      },
                      child: Image.file(
                        File(_imageFile.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        onImageSelected();
                        _imageFile = null;
                        setState(() {});
                      },
                      child: pastryshop.image != null
                          ? Image.network(
                              pastryshop.image,
                              width: 250,
                              fit: BoxFit.cover,
                            )
                          : Container(),
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
                      initialValue: pastryshop.name,
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
                      initialValue: pastryshop.ibam,
                      validator: (desc) {
                        if (desc.length < 3) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => pastryshop.description = desc,
                      labelText: 'Ibam',
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      initialValue: pastryshop.description,
                      validator: (desc) {
                        if (desc.length < 5) return 'Descrição';
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
                                          await pastryshop.save(
                                              idUserManger.user.id, _imageFile);
                                          context
                                              .read<PastryshopManager>()
                                              .update(pastryshop);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: const Text(
                                                  "Atualizado com sucesso"),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          );
                                          final pastryshops = context
                                              .watch<PastryshopManager>()
                                              ?.loadShop(idUserManger.user.id);
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

  void onImageSelected() async {
    final XFile pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}
