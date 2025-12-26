import 'package:flutter/material.dart';
import '../Logic/CardList.dart';

class ColeccionCard extends StatelessWidget {
  const ColeccionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ACCEDEMOS AL SINGLETON
    final lista = Cardlist().cards;

    double valorTotal = 0;
    if (lista.isNotEmpty) {
      valorTotal = lista.fold(0, (sum, item) => sum + item.precio);
    }

    // Estilos del tema actual
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias, //para que no se salga del card el icono
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.monetization_on_outlined,
                size: 140, // GIGANTE
              ),
            ),
          ),

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
                      "Valor de la colección",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

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
                    Text(
                      "Número de cartas: ${lista.length}",
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
