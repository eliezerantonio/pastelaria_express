import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TransferView extends StatelessWidget {
  TransferView(this.url, {Key key}) : super(key: key);
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
