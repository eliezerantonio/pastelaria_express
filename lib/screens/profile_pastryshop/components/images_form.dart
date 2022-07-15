import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  ImagesForm(this.newImages);

  List newImages;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(newImages),
      validator: (images) {
        if (images.isEmpty) {
          return 'Insira ao menos uma imagem';
        } else {
          return null;
        }
      },
      onSaved: (images) {
        newImages = images;
        print("--------------------$newImages");
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);

          Navigator.of(context).pop();
        }

        return Column(
          children: [
            CarouselSlider(
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
                ..add(Material(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
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
              options: CarouselOptions(autoPlay: false, viewportFraction: 2),
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
