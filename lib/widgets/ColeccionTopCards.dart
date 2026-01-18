import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';
import 'package:gestor_cartas/widgets/CardImage.dart';

// widget con las 4 cartas mas caras
class ColeccionTopCards extends StatelessWidget {
  const ColeccionTopCards({super.key});

  @override
  Widget build(BuildContext context) {
    // pillo la lista completa
    final lista = Cardlist().cards;

    // ordeno por precio y me quedo con las 4 primeras
    List orderedList = [
      ...lista..sort((a, b) => b.precio.compareTo(a.precio)),
    ].take(4).toList();

    // estilos del tema
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // creo el grid
    return GridView.builder(
      shrinkWrap: true, // para que no falle dentro del scroll
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.67, // formato vertical
      ),

      itemCount: orderedList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          clipBehavior: Clip.antiAlias, // recorto bordes
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardImage(
                  imagePath: orderedList[index].imagenPath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nombre de la carta
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
                        Expanded(
                          child: Text(
                            "${orderedList[index].coleccion} ",
                            style: textTheme.titleMedium,
                          ),
                        ),

                        // etiqueta de estado
                        ConditionChip(condition: orderedList[index].calidad),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 12),

                    // precio en grande
                    Text(
                      "${orderedList[index].precio.toStringAsFixed(2)} €",
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
