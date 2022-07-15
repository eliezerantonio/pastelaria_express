import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/user/user_manager.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      final user = userManager.user != null;
      return UserAccountsDrawerHeader(
        currentAccountPicture: ClipOval(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              "assets/img/avatar.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange[400],
              Colors.pink[300],
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        accountEmail: Text(
          user ? userManager.user.email : "Faca login para",
        ),
        accountName: Text(user ? userManager.user.name : "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      );
    });
  }
}
