import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pastelariaexpress/screens/loginscreen.dart';
import 'package:pastelariaexpress/screens/profile_pastryshop/profile_pastryshop_screen.dart';
import 'package:provider/provider.dart';

import '../../models/page_manager.dart';
import '../../models/user/user_manager.dart';
import '../admin_orders_screen/admin_orders_screen.dart';
import '../home_screen/home_screen.dart';
import '../orders/orders_screen.dart';
import '../pastryshops/pastryshops_screen.dart';
import '../signup_screen/signup_pastryshop_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController: pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              OrdersScreen(),
              AdminOrdersScreen(),
              SignUpPastryshopScreen(),
              const PastryshopsScreen(),
              ProfilePastryshopScreen(),
            ],
          );
        },
      ),
    );
  }
}
