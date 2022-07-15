import 'package:pastelariaexpress/components/custom_drawer/custom_drawer.dart';
import 'package:pastelariaexpress/imports.dart';

import 'components/components.dart';

class PastryshopsScreen extends StatefulWidget {
  const PastryshopsScreen({Key key}) : super(key: key);

  @override
  State<PastryshopsScreen> createState() => _PastryshopsScreenState();
}

class _PastryshopsScreenState extends State<PastryshopsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read<PastryshopManager>().loadAllShops();
  }

  @override
  Widget build(BuildContext context) {
    final pastryshops = context
        .watch<PastryshopManager>()
        .pastryshops
        .where((element) => element.deleted == false);

    return Scaffold(
      key: globalKey,
      drawer: const CustomDrawer(),
      appBar: appBarHome(context),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView(
              children: pastryshops.map((e) => PastryshopWidget(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  AppBar appBarHome(BuildContext context) {
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
    );
  }
}
