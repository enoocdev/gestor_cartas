import 'package:flutter/material.dart';
// Importamos tu modelo con un alias para evitar conflictos con el Widget Card
import 'package:gestor_cartas/Logic/Card.dart' as model;

class AddOrUpdatePage extends StatefulWidget {
  final model.Card? card; // Recibe la carta o null

  const AddOrUpdatePage({super.key, this.card});

  @override
  State<AddOrUpdatePage> createState() => _AddOrUpdatePageState();
}

class _AddOrUpdatePageState extends State<AddOrUpdatePage> {
  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _coleccionCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _imagenCtrl = TextEditingController();

  // Variable para el selector de estado
  String? _selectedCondition;

  // Lista de estados posibles
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

    if (widget.card != null) {
      _nombreCtrl.text = widget.card!.nombre;
      _coleccionCtrl.text = widget.card!.coleccion;
      _precioCtrl.text = widget.card!.precio.toString();

      if (_conditions.contains(widget.card!.calidad)) {
        _selectedCondition = widget.card!.calidad;
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _coleccionCtrl.dispose();
    _precioCtrl.dispose();
    _imagenCtrl.dispose();
    super.dispose();
  }

  // Simulación de guardar
  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      final String msg = widget.card == null
          ? "Carta creada"
          : "Carta actualizada";
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
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

                    _buildTextField(
                      controller: _nombreCtrl,
                      label: "Nombre de la carta",
                      icon: Icons.title,
                      validator: (value) =>
                          value!.isEmpty ? "El nombre es obligatorio" : null,
                    ),
                    const SizedBox(height: 15),

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
                        // Precio
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

                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedCondition,
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

                    // 5. BOTÓN PRINCIPAL (CREAR / ACTUALIZAR)
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

                    // 6. BOTÓN BORRAR (Solo si estamos editando)
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

  // --- Helpers para simplificar el código visual ---

  // Método para crear Input Decoration estilo "Dark Mode"
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[500]),
      filled: true,
    );
  }

  // Widget genérico para campos de texto
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
