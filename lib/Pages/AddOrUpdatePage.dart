import 'dart:io';

import 'package:flutter/material.dart';
// uso alias model para que no de error con el widget card
import 'package:gestor_cartas/Logic/Card.dart' as model;
import 'package:gestor_cartas/Logic/CardCondition.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/widgets/CardImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// pantalla para crear o editar cartas
class AddOrUpdatePage extends StatefulWidget {
  // si llega null es carta nueva
  final model.Card? card;

  const AddOrUpdatePage({super.key, this.card});

  @override
  State<AddOrUpdatePage> createState() => _AddOrUpdatePageState();
}

class _AddOrUpdatePageState extends State<AddOrUpdatePage> {
  // clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // controladores de texto para los inputs
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _coleccionCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _imagenCtrl = TextEditingController();

  // id y variables para guardar estado y foto
  int _cardId = 0;
  CardCondition? _selectedCondition;
  String? _selectedImage;

  // relleno los campos si vengo de editar
  @override
  void initState() {
    super.initState();

    if (widget.card != null) {
      _nombreCtrl.text = widget.card!.nombre;
      _coleccionCtrl.text = widget.card!.coleccion;
      _precioCtrl.text = widget.card!.precio.toString();
      _selectedImage = widget.card!.imagenPath;

      _selectedCondition = widget.card!.calidad;

      _cardId = widget.card!.codigo;
    }
  }

  // limpio memoria de los controladores al salir
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _coleccionCtrl.dispose();
    _precioCtrl.dispose();
    _imagenCtrl.dispose();
    super.dispose();
  }

  // abro galeria y guardo la foto en la carpeta de la app
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      await imagesDir.create(recursive: true);

      final ext = picked.name.contains('.')
          ? '.${picked.name.split('.').last}'
          : '';
      final fileName = 'card_${DateTime.now().millisecondsSinceEpoch}$ext';
      final savedPath = '${imagesDir.path}/$fileName';

      await File(picked.path).copy(savedPath);

      setState(() {
        _selectedImage = savedPath;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('imagen guardada')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error al guardar imagen $e')));
    }
  }

  // valido campos y guardo o actualizo la carta
  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      late String msg;

      if (widget.card == null) {
        Cardlist().addCard(
          _nombreCtrl.text,
          _selectedCondition,
          _coleccionCtrl.text,
          double.tryParse(_precioCtrl.text) ?? 0.0,
          _selectedImage ?? "",
        );
        msg = "carta creada";
      } else {
        Cardlist().updateCard(
          model.Card(
            codigo: _cardId,
            nombre: _nombreCtrl.text,
            calidad: _selectedCondition,
            coleccion: _coleccionCtrl.text,
            precio: double.tryParse(_precioCtrl.text) ?? 0.0,
            imagenPath: _selectedImage ?? "",
          ),
        );
        msg = "carta actualizada";
      }

      Cardlist().writeInJson();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      Navigator.pop(context);
    }
  }

  // borro carta de la lista y guardo cambios
  void _deleteCard() {
    Cardlist().delCard(_cardId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("carta eliminada"),
        backgroundColor: Colors.red,
      ),
    );

    Cardlist().writeInJson();
    Navigator.pop(context);
  }

  // construyo la interfaz del formulario
  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.card != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "editar carta" : "nueva carta")),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditing ? "detalles de la carta" : "rellena los datos",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: _selectImage,
                            child: Stack(
                              children: [
                                CardImage(
                                  imagePath: _selectedImage,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: _buildTextField(
                            controller: _nombreCtrl,
                            label: "nombre de la carta",
                            icon: Icons.title,
                            validator: (value) => value!.isEmpty
                                ? "el nombre es obligatorio"
                                : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _coleccionCtrl,
                      label: "coleccion set",
                      icon: Icons.layers,
                      validator: (value) =>
                          value!.isEmpty ? "la coleccion es obligatoria" : null,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildTextField(
                            controller: _precioCtrl,
                            label: "precio",
                            icon: Icons.euro,
                            isNumber: true,
                            validator: (value) {
                              if (value!.isEmpty) return "pon precio";
                              if (double.tryParse(value) == null) {
                                return "numero invalido";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 15),

                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<CardCondition>(
                            initialValue: _selectedCondition,
                            decoration: _inputDecoration(
                              "condicion",
                              Icons.star,
                            ),
                            items: CardCondition.values.map((
                              CardCondition condition,
                            ) {
                              return DropdownMenuItem<CardCondition>(
                                value: condition,
                                child: Text(condition.displayName),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCondition = newValue;
                              });
                            },
                            validator: (value) =>
                                value == null ? "elige estado" : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton.icon(
                      onPressed: _saveCard,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(
                        isEditing ? "actualizar carta" : "crear carta",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (isEditing)
                      OutlinedButton.icon(
                        onPressed: _deleteCard,
                        icon: const Icon(Icons.delete),
                        label: const Text("eliminar carta"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // estilo visual para los inputs
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[500]),
      filled: true,
    );
  }

  // widget para crear campos de texto rapido
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: validator,
      decoration: _inputDecoration(label, icon),
    );
  }
}
