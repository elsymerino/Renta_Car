import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String descripcion;

  CalendarPage(
      {required this.nombre, required this.imagen, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rentar $nombre'),
      ),
      body: Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          //color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // Aquí puedes agregar la lógica para manejar la fecha seleccionada
        print('Fecha seleccionada: $selectedDay');
      },
    );
  }
}
