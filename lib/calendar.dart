import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final String nombre;
  final String imagen;
  final String descripcion;

  CalendarPage({
    required this.nombre,
    required this.imagen,
    required this.descripcion,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  final _firestore = FirebaseFirestore.instance;

  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _numeroLicenciaController;
  late TextEditingController _tipoVehiculoController;
  late TextEditingController _metodoPagoController;

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now();
    _selectedEndDate = DateTime.now();

    _nombreController = TextEditingController();
    _edadController = TextEditingController();
    _numeroLicenciaController = TextEditingController();
    _tipoVehiculoController = TextEditingController();
    _metodoPagoController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _numeroLicenciaController.dispose();
    _tipoVehiculoController.dispose();
    _metodoPagoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RENTAR EL AUTO ${widget.nombre}'),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.imagen,
                  fit: BoxFit.cover,
                  height: 200,
                ),
                SizedBox(height: 16),
                Text(
                  widget.descripcion,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                _buildForm(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateField(
          'Fecha de Inicio',
          Icons.calendar_today,
          _selectedStartDate,
        ),
        _buildDateField(
          'Fecha de Finalización',
          Icons.calendar_today,
          _selectedEndDate,
        ),
        _buildInputField(
          labelText: 'Nombre Completo',
          icon: Icons.person,
          controller: _nombreController,
        ),
        _buildInputField(
          labelText: 'Edad',
          icon: Icons.date_range,
          controller: _edadController,
          keyboardType: TextInputType.number,
        ),
        _buildInputField(
          labelText: 'Número de Licencia',
          icon: Icons.card_membership,
          controller: _numeroLicenciaController,
        ),
        _buildInputField(
          labelText: 'Tipo de Vehículo',
          icon: Icons.directions_car,
          controller: _tipoVehiculoController,
        ),
        _buildInputField(
          labelText: 'Método de pago',
          icon: Icons.payment,
          controller: _metodoPagoController,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _saveFormData();
          },
          child: Text('Guardar'),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateField(String label, IconData icon, DateTime selectedDate) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(icon),
          onPressed: () {
            _selectDate(context, label);
          },
        ),
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context, label);
      },
      controller: TextEditingController(
        text: '${selectedDate.toLocal()}'.split(' ')[0],
      ),
    );
  }

  Widget _buildInputField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
    );
  }

  Future<void> _selectDate(BuildContext context, String label) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          label == 'Fecha de Inicio' ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        if (label == 'Fecha de Inicio') {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> _saveFormData() async {
    try {
      await _firestore.collection('renta').add({
        'nombre': _nombreController.text,
        'edad': int.parse(_edadController.text),
        'numero_licencia': _numeroLicenciaController.text,
        'fecha_inicio': _selectedStartDate,
        'fecha_fin': _selectedEndDate,
        'tipo_vehiculo': _tipoVehiculoController.text,
        'metodo_pago': _metodoPagoController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Información guardada en Firebase')),
      );
      _clearFormData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la información')),
      );
    }
  }

  void _clearFormData() {
    _nombreController.clear();
    _edadController.clear();
    _numeroLicenciaController.clear();
    _tipoVehiculoController.clear();
    _metodoPagoController.clear();
    setState(() {
      _selectedStartDate = DateTime.now();
      _selectedEndDate = DateTime.now();
    });
  }
}
