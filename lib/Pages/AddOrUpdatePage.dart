import 'dart:io';

import 'package:flutter/material.dart';
// Importamos el modelo con un alias para evitar conflictos con el Widget Card
// Se usa el alias model para diferenciar claramente el objeto de datos del widget visual
import 'package:gestor_cartas/Logic/Card.dart' as model;
// Importamos la enumeracion de condiciones de las cartas
import 'package:gestor_cartas/Logic/CardCondition.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/widgets/CardImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Pantalla que permite agregar una nueva carta o editar una existente
// Es un StatefulWidget porque maneja el estado del formulario
class AddOrUpdatePage extends StatefulWidget {
  // Recibe la carta a editar o null si es una carta nueva
  final model.Card? card;

  const AddOrUpdatePage({super.key, this.card});

  @override
  State<AddOrUpdatePage> createState() => _AddOrUpdatePageState();
}

class _AddOrUpdatePageState extends State<AddOrUpdatePage> {
  // Clave para validar el formulario
  // Sirve para comprobar que todos los campos cumplen las reglas antes de guardar
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  // Permiten leer y escribir texto dentro de los inputs
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _coleccionCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _imagenCtrl = TextEditingController();
  // Identificador de la carta para cuando estamos editando
  int _cardId = 0;
  // Variable para el selector de estado usando la enumeracion
  CardCondition? _selectedCondition;
  // Variable para la imagen seleccionada
  String? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Si la carta existe significa que estamos en modo edicion
    if (widget.card != null) {
      // Cargamos los datos de la carta en los controladores para que aparezcan en pantalla
      _nombreCtrl.text = widget.card!.nombre;
      _coleccionCtrl.text = widget.card!.coleccion;
      _precioCtrl.text = widget.card!.precio.toString();
      _selectedImage = widget.card!.imagenPath;

      // Asignamos directamente la calidad de la carta que ya es un CardCondition
      _selectedCondition = widget.card!.calidad;

      _cardId = widget.card!.codigo;
    }
  }

  @override
  void dispose() {
    // es importante liberar los controladores para evitar fugas de memoria
    _nombreCtrl.dispose();
    _coleccionCtrl.dispose();
    _precioCtrl.dispose();
    _imagenCtrl.dispose();
    super.dispose();
  }

  // Método para seleccionar imagen desde la galería
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return; // usuario canceló

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      await imagesDir.create(recursive: true);

      // Mantengo la extensión original del archivo
      final ext = picked.name.contains('.')
          ? '.${picked.name.split('.').last}'
          : '';
      final fileName = 'card_${DateTime.now().millisecondsSinceEpoch}$ext';
      final savedPath = '${imagesDir.path}/$fileName';

      // Copiar imagen al directorio de la app
      await File(picked.path).copy(savedPath);

      setState(() {
        _selectedImage = savedPath;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Imagen guardada')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error guardando la imagen: $e')));
    }
  }

  // Metodo para guardar la carta en la lista
  void _saveCard() {
    // Ejecutamos la validacion de todos los campos del formulario
    if (_formKey.currentState!.validate()) {
      late String msg;
      // Determinamos el mensaje segun si estamos creando o editando
      if (widget.card == null) {
        // Creamos una nueva carta pasando la condicion seleccionada
        Cardlist().addCard(
          _nombreCtrl.text,
          _selectedCondition,
          _coleccionCtrl.text,
          double.tryParse(_precioCtrl.text) ?? 0.0,
          _selectedImage ?? "",
        );
        msg = "Carta creada";
      } else {
        // Actualizamos la carta existente con los nuevos datos
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
        msg = "Carta actualizada";
      }
      // Guardamos los cambios en el archivo JSON
      Cardlist().writeInJson();

      // Mostramos un aviso visual al usuario
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      // Volver a la pantalla anterior
      Navigator.pop(context);
    }
  }

  // Metodo para eliminar la carta de la lista
  void _deleteCard() {
    // Eliminamos la carta por su identificador
    Cardlist().delCard(_cardId);

    // Mostramos mensaje de confirmacion con fondo rojo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Carta eliminada"),
        backgroundColor: Colors.red,
      ),
    );
    // Guardamos los cambios en el archivo JSON
    Cardlist().writeInJson();
    // Regresamos a la pantalla anterior tras borrar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // variable booleana para saber si el formulario es de edicion o creacion
    final bool isEditing = widget.card != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Carta" : "Nueva Carta")),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key:
                    _formKey, // vinculamos el formulario con nuestra clave global
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditing ? "Detalles de la Carta" : "Rellena los datos",
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
                                // Imagen circular
                                CardImage(
                                  imagePath: _selectedImage,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                // Círculo con icono + en la esquina inferior derecha
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
                            label: "Nombre de la carta",
                            icon: Icons.title,
                            validator: (value) => value!.isEmpty
                                ? "El nombre es obligatorio"
                                : null,
                          ),
                        ),
                      ],
                    ),

                    // campo para el nombre con validacion de texto vacio
                    const SizedBox(height: 15),

                    // campo para el set o coleccion
                    _buildTextField(
                      controller: _coleccionCtrl,
                      label: "Colección / Set",
                      icon: Icons.layers,
                      validator: (value) =>
                          value!.isEmpty ? "La colección es obligatoria" : null,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Precio con teclado numerico habilitado
                        Expanded(
                          flex: 1,
                          child: _buildTextField(
                            controller: _precioCtrl,
                            label: "Precio",
                            icon: Icons.euro,
                            isNumber: true,
                            validator: (value) {
                              if (value!.isEmpty) return "Pon precio";
                              if (double.tryParse(value) == null) {
                                return "Número inválido";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Selector desplegable para la calidad de la carta
                        // Usa los valores de la enumeracion CardCondition
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<CardCondition>(
                            initialValue: _selectedCondition,
                            decoration: _inputDecoration(
                              "Condicion",
                              Icons.star,
                            ),
                            // Generamos los items a partir de todos los valores de la enumeracion
                            items: CardCondition.values.map((
                              CardCondition condition,
                            ) {
                              return DropdownMenuItem<CardCondition>(
                                value: condition,
                                // Mostramos el nombre legible de la condicion
                                child: Text(condition.displayName),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCondition = newValue;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Elige estado" : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Boton principal
                    // cambia su icono y texto dinamicamente segun la accion
                    ElevatedButton.icon(
                      onPressed: _saveCard,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(
                        isEditing ? "ACTUALIZAR CARTA" : "CREAR CARTA",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Boton de borrar
                    // este boton solo aparece si el objeto card no es nulo
                    if (isEditing)
                      OutlinedButton.icon(
                        onPressed: _deleteCard,
                        icon: const Icon(Icons.delete),
                        label: const Text("ELIMINAR CARTA"),
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

  // Método para crear inputs
  // centraliza el estilo de los campos para que todos se vean iguales
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[500]),
      filled: true,
    );
  }

  // reduce la repeticion de codigo al crear los textformfield de la vista
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
