import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String descripcion;

  CalendarPage({
    required this.nombre,
    required this.imagen,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RENTAR EL AUTO $nombre'),
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
                  imagen,
                  fit: BoxFit.cover,
                  height: 200,
                ),
                SizedBox(height: 16),
                Text(
                  descripcion,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Seleccione una fecha para rentar:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                _buildCalendar(context),
                SizedBox(height: 16),
                Text(
                  'Complete el formulario:',
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

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime(
        DateTime.now().year + 1,
        DateTime.now().month,
        DateTime.now().day,
      ),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        print('Fecha seleccionada: $selectedDay');
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            labelText: 'Fecha de Inicio',
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Fecha de Finalización',
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
}
