import 'package:flutter/material.dart';
// Importamos tu modelo con un alias para evitar conflictos con el Widget Card
// se usa el alias model para diferenciar claramente el objeto de datos del widget visual
import 'package:gestor_cartas/Logic/Card.dart' as model;

class AddOrUpdatePage extends StatefulWidget {
  final model.Card? card; // Recibe la carta o null

  const AddOrUpdatePage({super.key, this.card});

  @override
  State<AddOrUpdatePage> createState() => _AddOrUpdatePageState();
}

class _AddOrUpdatePageState extends State<AddOrUpdatePage> {
  // Clave para validar el formulario
  // sirve para comprobar que todos los campos cumplen las reglas antes de guardar
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  // permiten leer y escribir texto dentro de los inputs
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _coleccionCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _imagenCtrl = TextEditingController();

  // Variable para el selector de estado
  String? _selectedCondition;

  // Lista de estados
  final List<String> _conditions = [
    'Mint',
    'Near Mint',
    'Excelent',
    'Good',
    'Light Played',
    'Played',
    'Poor',
  ];

  @override
  void initState() {
    super.initState();

    // si la carta existe significa que estamos en modo edicion
    if (widget.card != null) {
      // cargamos los datos de la carta en los controladores para que aparezcan en pantalla
      _nombreCtrl.text = widget.card!.nombre;
      _coleccionCtrl.text = widget.card!.coleccion;
      _precioCtrl.text = widget.card!.precio.toString();

      // verificamos que la calidad de la carta este en nuestra lista permitida
      if (_conditions.contains(widget.card!.calidad)) {
        _selectedCondition = widget.card!.calidad;
      }
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

  // Simulación de guardar
  void _saveCard() {
    // ejecutamos la validacion de todos los campos del formulario
    if (_formKey.currentState!.validate()) {
      // determinamos el mensaje segun si estamos creando o editando
      final String msg = widget.card == null
          ? "Carta creada"
          : "Carta actualizada";

      // mostramos un aviso visual al usuario
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      Navigator.pop(context); // Volver atrás
    }
  }

  // Simulación de borrar
  void _deleteCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Carta eliminada"),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context); // regresamos a la pantalla anterior tras borrar
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

                    // campo para el nombre con validacion de texto vacio
                    _buildTextField(
                      controller: _nombreCtrl,
                      label: "Nombre de la carta",
                      icon: Icons.title,
                      validator: (value) =>
                          value!.isEmpty ? "El nombre es obligatorio" : null,
                    ),
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

                        // selector desplegable para la calidad de la carta
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue:
                                _selectedCondition, // estado iniical del selector
                            decoration: _inputDecoration(
                              "Condición",
                              Icons.star,
                            ),
                            dropdownColor: const Color(0xFF2B2B2B),
                            items: _conditions.map((String condition) {
                              return DropdownMenuItem<String>(
                                value: condition,
                                child: Text(condition),
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
