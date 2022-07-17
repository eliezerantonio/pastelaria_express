import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/pastryshop/pastryshop.dart';
import '../../../models/user/user_manager.dart';

class PastryshopWidget extends StatelessWidget {
  const PastryshopWidget(this.pastryshop);
  final Pastryshop pastryshop;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserManager>().user;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/orders', arguments: pastryshop);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedNetworkImage(
                imageUrl: pastryshop.image,
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pastryshop.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 80,
                        alignment: Alignment.center,
                        child: Text(
                          "${pastryshop.likes}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 22,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          "${pastryshop.dislikes} ",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(pastryshop.description),
                ],
              ),
            ),
            if (user.superUser)
              IconButton(
                onPressed: () {
                  pastryshop.delete();
                },
                icon: const Icon(Icons.delete, color: Colors.grey),
              )
          ],
        ),
      ),
    );
  }
}
