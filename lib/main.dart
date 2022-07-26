import 'package:pastelariaexpress/models/admin/admin_orders_manager.dart';
import 'package:pastelariaexpress/models/cart/cart_product.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';
import 'package:pastelariaexpress/screens/base/base_screen.dart';
import 'package:pastelariaexpress/screens/confirmation/confirmation_screen.dart';
import 'package:pastelariaexpress/screens/loginscreen.dart';
import 'package:pastelariaexpress/screens/signup_screen/signup_screen.dart';

import 'imports.dart';
import 'models/cart/cart_manager.dart';
import 'models/order/order.dart';
import 'models/order/orders_manager.dart';
import 'models/product/product.dart';
import 'models/product/product_manager.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/edit_product/edit_product_screen.dart';
import 'screens/pastryshops/pastryshops_orders_screen.dart';
import 'screens/product/product_screen.dart';
import 'screens/products_screen/products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => Product(),
          lazy: false,
        ), 
        ChangeNotifierProvider(
          create: (context) => PageManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, PastryshopManager>(
          create: (_) => PastryshopManager(),
          update: (_, userManager, storesManager) =>
              storesManager..checkUser(userManager: userManager),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, ProductManager>(
          create: (_) => ProductManager(),
          lazy: false,
          update: (_, userManager, productManager) =>
              productManager..loadAllProducts(userManager: userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(
                adminEnable: userManager.adminEnabled, user: userManager.user),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Pastelaria Express',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Colors.black,
                ),
          ),
          iconTheme:
              Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
          primaryIconTheme:
              Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
          primaryColor: Colors.pink[300],
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.grey),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
            case '/products':
              return MaterialPageRoute(
                builder: (_) => ProductsScreen(
                  pastryshop: settings.arguments as Pastryshop,
                ),
              );
            case '/':
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => CadastroScreen(),
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(settings.arguments as Product),
              );  case '/orders':
              return MaterialPageRoute(
                builder: (_) =>
                    PastryshopsOrdersScreen(settings.arguments as Pastryshop),
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Product),
              );
            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => CheckoutScreen(),
              );
              break;
            case '/confirmation':
              return MaterialPageRoute(
                builder: (_) => ConfirmationScreen(settings.arguments as Order),
              );
              break;
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(), settings: settings);

            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
