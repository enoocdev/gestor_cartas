import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';

// Este widget muestra una cuadricula con las 4 cartas mas valiosas de la coleccion
class ColeccionTopCards extends StatelessWidget {
  const ColeccionTopCards({super.key});

  @override
  Widget build(BuildContext context) {
    // Se accede a los datos globales
    final lista = Cardlist().cards;

    // .. hace que me devuelva una lista diferente y no m modifique la original
    // Se ordena de mayor a menor precio y se toman solo los primeros 4 elementos
    List orderedList = [
      ...lista..sort((a, b) => b.precio.compareTo(a.precio)),
    ].take(4).toList();

    // Se obtienen los colores y estilos de texto definidos en el tema de la app
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Se construye una cuadricula que se ajusta al contenido disponible
    return GridView.builder(
      shrinkWrap: true, // Importante para que no de error dentro de un scroll
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Se definen dos columnas
        crossAxisSpacing: 10, // Espacio horizontal entre tarjetas
        mainAxisSpacing: 10, // Espacio vertical entre tarjetas
        childAspectRatio:
            0.67, // Relacion de aspecto para que las tarjetas sean alargadas
      ),

      itemCount: orderedList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          clipBehavior: Clip
              .antiAlias, // Evita que la imagen sobresalga de los bordes redondeados
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mantiene la proporcion de la imagen sin importar el tamaño de la pantalla
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.asset(
                  "assets/images/underground_sea.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Muestra el nombre de la carta limitado a una sola linea
                    Text(
                      "${orderedList[index].nombre} ",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),

                      maxLines: 1,
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre de la coleccion que ocupa el espacio sobrante
                        Expanded(
                          child: Text(
                            "${orderedList[index].coleccion} ",
                            style: textTheme.titleMedium,
                          ),
                        ),

                        // Reutiliza el chip de condicion para mostrar la calidad
                        ConditionChip(condition: orderedList[index].calidad),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 12),

                    // Precio destacado en la parte inferior de la tarjeta
                    Text(
                      "${orderedList[index].precio.toStringAsFixed(2)} €", // Variable: orderedList[index].precio
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
