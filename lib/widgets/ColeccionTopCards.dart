import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';

class ColeccionTopCards extends StatelessWidget {
  const ColeccionTopCards({super.key});

  @override
  Widget build(BuildContext context) {
    final lista = Cardlist().cards;

    // .. hace que me devuelva una lista diferente y no m modifique la original
    List orderedList = [
      ...lista..sort((a, b) => b.precio.compareTo(a.precio)),
    ].take(4).toList();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.67,
      ),

      itemCount: orderedList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

                        ConditionChip(condition: orderedList[index].calidad),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 12),

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
