import 'dart:io';

import 'package:flutter/material.dart';

/// Widget que muestra una imagen de carta con validaciones
/// Soporta tanto assets como archivos locales
/// Si la imagen no existe o la ruta es inválida, muestra un icono por defecto
class CardImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CardImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Si no hay imagen o está vacía, mostrar icono por defecto
    if (imagePath == null || imagePath!.isEmpty) {
      imageWidget = Center(
        child: Icon(
          Icons.person,
          size: width > height ? height * 0.6 : width * 0.6,
        ),
      );
    } else {
      // Detectar si es asset o archivo local
      final isAsset = imagePath!.startsWith('assets/');

      if (isAsset) {
        // Cargar como asset
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
        // Cargar como archivo local
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

    final container = Container(
      width: width,
      height: height,
      child: imageWidget,
    );

    // Aplicar borderRadius si se proporciona
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: container);
    }

    return container;
  }
}
