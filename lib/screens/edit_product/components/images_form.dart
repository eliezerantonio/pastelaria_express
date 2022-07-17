import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/product/product.dart';
import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images.isEmpty) {
          return 'Insira ao menos uma imagem';
        } else {
          return null;
        }
      },
      onSaved: (images) => product.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);

          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: CarouselSlider(
                items: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      //Image
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()
                  ..add(SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: const Icon(Icons.cake),
                        onPressed: () {
                          if (Platform.isAndroid) {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          } else if (Platform.isIOS) {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        iconSize: 50,
                      ),
                    ),
                  )),
                options: CarouselOptions(autoPlay: false, viewportFraction: 1),
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
          ],
        );
      },
    );
  }
}
