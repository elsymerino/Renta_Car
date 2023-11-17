import 'package:flutter/material.dart';
import 'package:rentacar/calendar.dart';

class Rentar extends StatefulWidget {
  const Rentar({Key? key});

  @override
  State<Rentar> createState() => _RentarState();
}

class _RentarState extends State<Rentar> {
  final List<Map<String, dynamic>> _allAutos = [
    {
      "id": 1,
      "name": "Ferrari",
      "precio": 1000,
      "imagen":
          "https://phantom-expansion.unidadeditorial.es/d99e9afff02c3ac173b6d6f827f3a551/crop/0x725/2043x1875/resize/828/f/webp/assets/multimedia/imagenes/2022/05/20/16530388017130.jpg",
      "descripcion": "Automovil SuperDeportivo",
      "categoria": "Cerrados",
    },
    {
      "id": 2,
      "name": "Honda",
      "precio": 500,
      "imagen":
          "https://hips.hearstapps.com/hmg-prod/images/199431-honda-muestra-su-renovado-civic-type-r-en-el-tokyo-auto-salon-2020-1578660923.jpg",
      "descripcion": "Carro casual con excelente motor",
      "categoria": "Cerrados",
    },
    {
      "id": 3,
      "name": "Hiunday",
      "precio": 200,
      "imagen":
          "https://s7d1.scene7.com/is/image/hyundai/2021-elantra-hev-0223-without-talent-and-cars-1:4-3?qlt=85,0&fmt=webp",
      "descripcion": "Sedan clasico",
      "categoria": "Cerrados",
    },
    {
      "id": 4,
      "name": "Jeep Cherokee",
      "precio": 300,
      "imagen":
          "https://upload.wikimedia.org/wikipedia/commons/f/fd/2019_Jeep_Cherokee_Latitude_front_5.27.18.jpg",
      "descripcion": "Camioneta de 4 puertas",
      "categoria": "Camionetas",
    },
    {
      "id": 5,
      "name": "Range Rover 2024",
      "precio": 700,
      "imagen":
          "https://hips.hearstapps.com/hmg-prod/images/2023-range-rover-sport-101-1652153925.jpg",
      "descripcion": "Camioneta de lujo",
      "categoria": "Camionetas",
    },

    {
      "id": 6,
      "name": "Honda CR-V",
      "precio": 360,
      "imagen":
          "https://horsepowermexico.com/wp-content/uploads/2020/10/hondacrv-scaled.jpg",
      "descripcion": "Camioneta de lujo",
      "categoria": "Camionetas",
    },

    {
      "id": 6,
      "name": "Toyota Hilux 2022",
      "precio": 500,
      "imagen":
          "https://autosdeprimera.com/wp-content/uploads/2022/12/toyota-hilux-srx-diesel-4x4-a.jpg",
      "descripcion": "Para equipamento pesado",
      "categoria": "Picat",
    },
    // Agrega los demás autos con sus imágenes, detalles y categorías
    // https://horsepowermexico.com/wp-content/uploads/2020/10/hondacrv-scaled.jpg
  ];

  List<Map<String, dynamic>> _foundAutos = [];

  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Picat', 'Cerrados', 'Camionetas'];

  @override
  initState() {
    _foundAutos = _allAutos;
    super.initState();
  }

  void _runFilter(String selectedCategory) {
    List<Map<String, dynamic>> results = [];
    if (selectedCategory == 'All') {
      results = _allAutos;
    } else {
      results = _allAutos
          .where((auto) =>
              auto["categoria"] != null &&
              auto["categoria"].toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }
    setState(() {
      _foundAutos = results;
    });
  }

  void _addToCart(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                _foundAutos[index]["imagen"],
                fit: BoxFit.cover,
                height: 450,
              ),
              SizedBox(height: 16),
              Text(
                _foundAutos[index]["descripcion"],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarPage(
                        nombre: _foundAutos[index]['name'],
                        imagen: _foundAutos[index]['imagen'],
                        descripcion: _foundAutos[index]['descripcion'],
                      ),
                    ),
                  );
                },
                child: Text('Rentar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Listview'),
        backgroundColor: Colors.amber,
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
                _runFilter(_selectedCategory);
              });
            },
            items: _categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _foundAutos.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _foundAutos.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              height: 250,
                              child: Image.network(
                                _foundAutos[index]["imagen"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              _foundAutos[index]['name'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              '\$${_foundAutos[index]["precio"].toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.black),
                            ),
                            ElevatedButton(
                              onPressed: () => _addToCart(index),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber, // Color del botón
                              ),
                              child: Text(
                                'Agregar al carrito',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
