import 'package:flutter/material.dart';
import 'package:pastelariaexpress/screens/signup_screen/signup_screen.dart';

import '../screens/home_screen/home_screen.dart';
import '../screens/loginscreen.dart';
import '../screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case LOGIN_SCREEN:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case SIGNUP_SCREEN:
        return MaterialPageRoute(
          builder: (_) => CadastroScreen(),
        );
      case HOME_SCREEN:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<MaterialPageRoute> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Tela nao encotrada"),
        ),
        body: const Center(
          child: Text("Tela nao encotrada"),
        ),
      ),
    );
  }
}
