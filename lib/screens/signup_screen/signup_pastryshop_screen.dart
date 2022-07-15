import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/custom_button.dart';
import '../../components/custom_drawer/custom_drawer.dart';
import '../../components/custom_textfield.dart';
import '../../models/user/user_manager.dart';
import '../../models/user/user_model.dart';

class SignUpPastryshopScreen extends StatefulWidget {
  @override
  _SignUpPastryshopScreenState createState() => _SignUpPastryshopScreenState();
}

class _SignUpPastryshopScreenState extends State<SignUpPastryshopScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final UserModel user = UserModel();

  final size = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Criar Conta Pastelaria",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return ListView(
              shrinkWrap: true, //ocupa menor espaco possivel

              children: [
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        hintText: "Nome",
                        labelText: "Insira  nome",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.white),
                        onSaved: (name) => user.name = name,
                        validator: (name) {
                          if (name.trim().isEmpty) {
                            return 'Infome nome e sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        onSaved: (phone) => user.phone = phone,
                        labelText: "Telefone",
                        keyboardType: TextInputType.phone,
                        prefixIcon:
                            const Icon(Icons.phone, color: Colors.white),
                        validator: (name) {
                          if (name.trim().isEmpty) {
                            return 'Infome nome e sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        onSaved: (email) => user.email = email,
                        labelText: "E-mail",
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        onSaved: (password) => user.password = password,
                        labelText: "Senha",
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        onSaved: (confirmPassword) =>
                            user.confirmPassword = confirmPassword,
                        labelText: "Repetir senha",
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      userManager.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.redAccent,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : SizedBox(
                              height: 47,
                              child: CustomButton(
                                onPressed: userManager.loading
                                    ? null
                                    : () {
                                        formKey.currentState.save();

                                        if (user.name.trim().isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Digite o Nome'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (user.phone.trim().isEmpty ||
                                            user.phone.length < 9 ||
                                            user.phone.length > 9) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Digite o telefone'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (user.email.trim().isEmpty ||
                                            !user.email.contains("@")) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Digite o E-mail'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (user.password.trim().isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Digite a senha'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (user.password !=
                                            user.confirmPassword) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Senha diferentes'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        _signUp();
                                      },
                                text: 'Criar Conta',
                              ),
                            ),
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

  void _signUp() {
    final userManager = context.read<UserManager>();
    userManager.signUp(
      admin: true,
      user: user,
      onSuccess: () {
        Navigator.pushNamed(context, '/base');
      },
      onFail: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao cadastrar! $e'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
