import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/user/user_manager.dart';
import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const CustomDrawerHeader(),
              const DrawerTile(iconData: Icons.home, title: 'Inicio', page: 0),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (!userManager.superEnabled && !userManager.adminEnabled) {
                  return const DrawerTile(
                    iconData: Icons.playlist_add_check,
                    title: 'Pedidos',
                    page: 1,
                  );
                } else {
                  return Container();
                }
              }),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (!userManager.isLogged) {
                  return Column(
                    children: const <Widget>[
                      Divider(),
                      DrawerTile(
                          iconData: Icons.login,
                          title: 'login/criar conta',
                          page: 2),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: const <Widget>[
                      Divider(),
                      DrawerTile(
                          iconData: Icons.settings, title: 'Pedidos', page: 3),
                      DrawerTile(
                          iconData: Icons.settings,
                          title: 'Perfil Pastelaria',
                          page: 6),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.superEnabled) {
                  return Column(
                    children: const <Widget>[
                      Divider(),
                      DrawerTile(
                          iconData: Icons.settings,
                          title: 'Criar Pastelaria',
                          page: 4),
                      DrawerTile(
                          iconData: Icons.settings,
                          title: 'Ver Taxas de Pastelarias',
                          page: 5),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.isLogged) {
                  return SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Divider(),
                        TextButton(
                          child: Text(
                            "Sair",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          onPressed: () {
                            userManager.signOut();
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
