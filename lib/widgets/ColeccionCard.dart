import 'package:flutter/material.dart';
import '../Logic/CardList.dart';

// Este widget muestra una tarjeta con el resumen economico de toda la coleccion
// Calcula y muestra el valor total y el numero de cartas almacenadas
class ColeccionCard extends StatelessWidget {
  const ColeccionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Se obtiene la lista global de cartas para realizar los calculos
    final lista = Cardlist().cards;

    // Se inicializa el sumatorio del valor de las cartas
    double valorTotal = 0;
    if (lista.isNotEmpty) {
      // Se usa fold para recorrer la lista y acumular la suma de los precios de forma eficiente
      valorTotal = lista.fold(0, (sum, item) => sum + item.precio);
    }

    // Estilos del tema actual para que los colores se adapten si es modo claro u oscuro
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      // Sombra pronunciada para darle profundidad a la tarjeta
      elevation: 9,
      // Bordes redondeados de 20 pixeles
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Para que no se salga del card el icono decorativo
      clipBehavior: Clip.antiAlias,
      child: Stack(
        // Se usa un stack para colocar elementos uno encima de otro
        children: [
          // Icono decorativo de fondo posicionado en la esquina inferior derecha
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              // Opacidad baja para que no moleste a la lectura del texto
              opacity: 0.2,
              child: Icon(Icons.monetization_on_outlined, size: 140),
            ),
          ),

          // Contenedor principal con la informacion de la coleccion
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Icono de cartera con el color primario del tema
                    Icon(Icons.wallet, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    // Texto descriptivo de la seccion
                    Text(
                      "Valor de la coleccion",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Muestra el precio total calculado formateado a dos decimales
                Text(
                  "${valorTotal.toStringAsFixed(2)} €",
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 15),
                // Linea para separar el valor del conteo total
                const Divider(),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // Icono para el contador de cartas
                    Icon(Icons.style, color: colorScheme.secondary, size: 20),
                    const SizedBox(width: 8),
                    // Indica cuantas cartas hay almacenadas actualmente
                    Text(
                      "Numero de cartas: ${lista.length}",
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
