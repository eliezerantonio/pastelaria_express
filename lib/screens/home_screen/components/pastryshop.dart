import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/pastryshop/pastryshop.dart';
import '../../../models/pastryshop/pastryshop_mananger.dart';
import '../../../models/user/user_manager.dart';

class PastryshopWidget extends StatelessWidget {
  const PastryshopWidget(this.pastryshop);
  final Pastryshop pastryshop;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserManager>().user;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/products',
          arguments: pastryshop,
        );
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.thumb_up, color: Colors.blue),
                            onPressed: user != null && !user.admin
                                ? () {
                                    if (pastryshop.classifiers
                                        .contains(user.id)) return;
                                    pastryshop.like();
                                     context
                                        .read<PastryshopManager>()
                                        .increment(pastryshop);
                                  }
                                : null,
                          ),
                          Text(
                            "${pastryshop.likes}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.thumb_down, color: Colors.red),
                            onPressed: user != null && !user.admin
                                ? () {
                                    if (pastryshop.classifiers
                                        .contains(user.id)) return;
                                    pastryshop.dislike();
                                  }
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${pastryshop.dislikes} ",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(pastryshop.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
