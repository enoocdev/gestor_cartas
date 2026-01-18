import 'package:flutter/material.dart';
import '../Logic/CardList.dart';

// widget que muestra el resumen de dinero y cartas
class ColeccionCard extends StatelessWidget {
  const ColeccionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // pillo la lista global para calcular
    final lista = Cardlist().cards;

    // calculo el valor total sumando los precios
    double valorTotal = 0;
    if (lista.isNotEmpty) {
      valorTotal = lista.fold(0, (sum, item) => sum + item.precio);
    }

    // cojo los colores y textos del tema
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // corto lo que sobresalga del card
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // icono gigante de fondo medio transparente
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Icon(Icons.monetization_on_outlined, size: 140),
            ),
          ),

          // contenido principal con los datos
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.wallet, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "valor de la coleccion",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // precio total formateado
                Text(
                  "${valorTotal.toStringAsFixed(2)} €",
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.style, color: colorScheme.secondary, size: 20),
                    const SizedBox(width: 8),
                    // muestro cuantas cartas hay en total
                    Text(
                      "numero de cartas: ${lista.length}",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
