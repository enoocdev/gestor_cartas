// Importamos dart io para manejar archivos del sistema
import 'dart:io';

import 'package:flutter/material.dart';

// Widget que muestra una imagen de carta con validaciones
// Soporta tanto assets como archivos locales del dispositivo
// Si la imagen no existe o la ruta es invalida muestra un icono por defecto
class CardImage extends StatelessWidget {
  // Ruta de la imagen puede ser un asset o un archivo local
  final String? imagePath;
  // Ancho del contenedor de la imagen
  final double width;
  // Alto del contenedor de la imagen
  final double height;
  // Como se ajusta la imagen dentro del contenedor
  final BoxFit fit;
  // Radio de los bordes opcional para hacer la imagen circular o redondeada
  final BorderRadius? borderRadius;

  // Constructor que recibe todos los parametros necesarios
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

    // Si no hay imagen o esta vacia mostramos un icono por defecto
    if (imagePath == null || imagePath!.isEmpty) {
      imageWidget = Center(
        child: Icon(
          Icons.person,
          // El tamano del icono se ajusta segun las dimensiones del contenedor
          size: width > height ? height * 0.6 : width * 0.6,
        ),
      );
    } else {
      // Detectamos si es un asset o un archivo local por el prefijo de la ruta
      final isAsset = imagePath!.startsWith('assets/');

      if (isAsset) {
        // Cargamos la imagen como asset del proyecto
        imageWidget = Image.asset(
          imagePath!,
          fit: fit,
          width: width,
          height: height,
          // Si hay error al cargar mostramos el icono por defecto
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
        // Cargamos la imagen como archivo local del dispositivo
        imageWidget = Image.file(
          File(imagePath!),
          fit: fit,
          width: width,
          height: height,
          // Si hay error al cargar mostramos el icono por defecto
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

    // Creamos el contenedor con las dimensiones especificadas
    final box = SizedBox(width: width, height: height, child: imageWidget);

    // Si se proporciona borderRadius aplicamos el recorte redondeado
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: box);
    }

    return box;
  }
}
