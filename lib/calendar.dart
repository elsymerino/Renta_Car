import 'package:flutter/material.dart';
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
          decoration: InputDecoration(
            labelText: 'Nombre Completo',
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Edad',
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Número de Licencia',
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Tipo de Vehículo',
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Método de pago',
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar el formulario
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
}
