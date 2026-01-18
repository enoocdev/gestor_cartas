import 'dart:io';

import 'package:flutter/material.dart';

// widget para pintar la imagen de la carta sea asset o archivo local
class CardImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  // constructor con los parametros de tamano y ruta
  const CardImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  // construyo la imagen comprobando si es asset archivo o si esta vacia
  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath == null || imagePath!.isEmpty) {
      imageWidget = Center(
        child: Icon(
          Icons.person,
          size: width > height ? height * 0.6 : width * 0.6,
        ),
      );
    } else {
      final isAsset = imagePath!.startsWith('assets/');

      if (isAsset) {
        // si empieza por assets uso image asset
        imageWidget = Image.asset(
          imagePath!,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person,
                size: width > height ? height * 0.6 : width * 0.6,
              ),
            );
          },
        );
      } else {
        // si no es asset intento cargarla desde el archivo local
        imageWidget = Image.file(
          File(imagePath!),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person,
                size: width > height ? height * 0.6 : width * 0.6,
              ),
            );
          },
        );
      }
    }

    // meto la imagen en una caja con el tamano y recorto si hace falta
    final box = SizedBox(width: width, height: height, child: imageWidget);

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: box);
    }

    return box;
  }
}
