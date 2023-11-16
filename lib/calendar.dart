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

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _numeroLicenciaController =
      TextEditingController();
  final TextEditingController _tipoVehiculoController = TextEditingController();
  final TextEditingController _metodoPagoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now();
    _selectedEndDate = DateTime.now();
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
            'Fecha de Inicio', Icons.calendar_today, _selectedStartDate),
        _buildDateField(
            'Fecha de Finalización', Icons.calendar_today, _selectedEndDate),
        TextFormField(
          controller: _nombreController,
          decoration: InputDecoration(
            labelText: 'Nombre Completo',
          ),
        ),
        TextFormField(
          controller: _edadController,
          decoration: InputDecoration(
            labelText: 'Edad',
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: _numeroLicenciaController,
          decoration: InputDecoration(
            labelText: 'Número de Licencia',
          ),
        ),
        TextFormField(
          controller: _tipoVehiculoController,
          decoration: InputDecoration(
            labelText: 'Tipo de Vehículo',
          ),
        ),
        TextFormField(
          controller: _metodoPagoController,
          decoration: InputDecoration(
            labelText: 'Método de pago',
          ),
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
        'edad': int.tryParse(_edadController.text) ?? 0,
        'numero_licencia': _numeroLicenciaController.text,
        'fecha_inicio': _selectedStartDate,
        'fecha_fin': _selectedEndDate,
        'tipo_vehiculo': _tipoVehiculoController.text,
        'metodo_pago': _metodoPagoController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Información guardada en Firebase')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la información')),
      );
    }
  }
}
