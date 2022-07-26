import 'package:flutter/material.dart';
import 'package:pastelariaexpress/components/custom_textfield.dart';
import 'package:pastelariaexpress/models/user/user_manager.dart';
import 'package:pastelariaexpress/models/user/user_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_button.dart';

const SIGNUP_SCREEN = "/sigup_screen";

class CadastroScreen extends StatelessWidget {
  CadastroScreen({Key key}) : super(key: key);

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final UserModel userModel = UserModel();
    return Scaffold(
      body: Form(
        key: form,
        child: SafeArea(
          child: Consumer<UserManager>(
            builder: (_, userManager, __) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(height: 17),
                      Center(
                        child: Text(
                          "Cadastro",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.pink[300]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                            "Efectue o seu cadastro para poder criar uma conta na nossa Pastelaria Virtual",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        " Nome ",
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Nome",
                        labelText: "Insira seu nome",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.white),
                        onSaved: (name) => userModel.name = name,
                        validator: (name) {
                          if (name.trim().isEmpty || !name.contains(" ")) {
                            return 'Infome nome e sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "  Email ",
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Email",
                        labelText: "Insira o seu email",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                        onSaved: (email) => userModel.email = email,
                        validator: (email) {
                          if (email.trim().isEmpty || !email.contains("@")) {
                            return 'Email deve ser preenchidos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "  Número ",
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Número",
                        labelText: "Insira o seu número",
                        keyboardType: TextInputType.number,
                        prefixIcon:
                            const Icon(Icons.phone, color: Colors.white),
                        onSaved: (phone) => userModel.phone = phone,
                        validator: (phone) {
                          if (phone.trim().isEmpty || phone.trim().length < 9) {
                            return 'Informe telefone valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "  Senha",
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Senha",
                        obscureText: true,
                        labelText: "Insira a sua senha",
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        onSaved: (password) => userModel.password = password,
                        validator: (password) {
                          if (password.trim().isEmpty ||
                              password.trim().length < 6) {
                            return 'A senha deve conter no minimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "  Confirmar senha",
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Senha",
                        obscureText: true,
                        labelText: "Confirme a sua senha",
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        onSaved: (confirmPassword) =>
                            userModel.confirmPassword = confirmPassword,
                        validator: (password) {
                          if (password.trim() != userModel.password) {
                            return 'As senhas nao coecidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 47,
                        width: size.width,
                        child: CustomButton(
                          onPressed: () {
                            form.currentState.save();
                            if (form.currentState.validate()) {
                              userManager.signUp(
                                user: userModel,
                                onFail: (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao Entrar $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                onSuccess: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/base');
                                },
                              );
                            }
                          },
                          text: 'Cadastrar',
                        ),
                      ),
                      if (userManager.loading)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.pink[300],
                          )),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
