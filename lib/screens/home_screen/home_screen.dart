import 'package:pastelariaexpress/components/custom_drawer/custom_drawer.dart';
import 'package:pastelariaexpress/imports.dart';

import '../../models/cart/cart_manager.dart';
import '../../models/cart/cart_product.dart';
import 'components/components.dart';

const HOME_SCREEN = "/home_screen";

class HomeScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  HomeScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pastryshops = context
        .watch<PastryshopManager>()
        .pastryshops
        .where((element) => element.deleted == false);
    final items = context.watch<CartManager>().items;
    final user = context.watch<UserManager>().adminEnabled;

    return Scaffold(
      key: globalKey,
      drawer: const CustomDrawer(),
      appBar: appBarHome(context, items),
      body: Column(
        children: [
          if (!user) ...[
            const SearchField(),
            Expanded(child: CarouselSliderHome()),
          ],
          const SizedBox(height: 3),
          Expanded(
            flex: 3,
            child: ListView(
              children: pastryshops.map((e) => PastryshopWidget(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  AppBar appBarHome(BuildContext context, List<CartProduct> items) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: Colors.black,
        onPressed: () {
          globalKey.currentState.openDrawer();
        },
      ),
      title: const Text("Pastelaria Express",
          style: TextStyle(color: Colors.black)),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/cart');
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.grey[300],
                  size: 30,
                ),
              ),
              if (items.isNotEmpty)
                Positioned(
                  right: 29,
                  left: 0,
                  child: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      items.length.toString(),
                      style: const TextStyle(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
