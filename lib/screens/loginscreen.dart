import 'package:flutter/material.dart';
import 'package:pastelariaexpress/models/user/user_model.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../models/user/user_manager.dart';

const LOGIN_SCREEN = "/login_screen";

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = UserModel();
    final userManager = context.read<UserManager>();
    return Scaffold(
        key: globalKey,
        drawer: const CustomDrawer(),
        body: Form(
          key: formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  background(size),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    margin: EdgeInsets.only(
                        top: size.height * 0.3,
                        left: size.width * 0.03,
                        right: size.width * 0.03),
                    height: 450,
                    width: size.width,
                    child: Card(
                      elevation: 7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: Colors.pink[300]),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "  Email ",
                              style: TextStyle(
                                  color: Colors.pink[300],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              onSaved: ((email) => user.email = email),
                              validator: (email) {
                                if (email.trim().isEmpty ||
                                    !email.contains("@")) {
                                  return 'Email deve ser preenchidos';
                                }
                                return null;
                              },
                              hintText: "Email",
                              labelText: "Insira o seu email",
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "  Senha",
                              style: TextStyle(
                                  color: Colors.pink[300],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              onSaved: ((password) => user.password = password),
                              hintText: "Senha",
                              obscureText: true,
                              labelText: "Insira a sua senha",
                              validator: (password) {
                                if (password.trim().isEmpty ||
                                    password.trim().length < 6) {
                                  return 'A senha deve conter no minimo 6 caracteres';
                                }
                                return null;
                              },
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.white),
                            ),
                            const SizedBox(height: 15),
                            CustomButton(
                              onPressed: () {
                                formKey.currentState.save();
                                if (formKey.currentState.validate()) {
                                  userManager.signIn(
                                    user: user,
                                    onFail: (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Preencha todos campos'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              text: "Entrar",
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: TextButton(
                                onPressed: !userManager.loading
                                    ? () {
                                        Navigator.pushNamed(context, "/signup");
                                      }
                                    : null,
                                child: const Text(
                                  "Criar uma conta",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 116, 116, 116)),
                                ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      globalKey.currentState.openDrawer();
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Container background(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink[300],
            Colors.orange[300],
          ],
        ),
      ),
      child: Center(
        child: Image.asset("assets/img/LogoDD_Branco@300x.png"),
      ),
    );
  }
}
