import 'package:flutter/material.dart';

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
      "descripcion": "",
      "categoria": "picat",
    },
    {
      "id": 2,
      "name": "Honda",
      "precio": 500,
      "imagen":
          "https://hips.hearstapps.com/hmg-prod/images/199431-honda-muestra-su-renovado-civic-type-r-en-el-tokyo-auto-salon-2020-1578660923.jpg",
      "descripcion": "",
      "categoria": "cerrados",
    },
    {
      "id": 3,
      "name": "Hiunday",
      "precio": 500,
      "imagen":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/0_Hyundai_Tucson_%28NX4%29_1.jpg/1200px-0_Hyundai_Tucson_%28NX4%29_1.jpg",
      "descripcion": "",
      "categoria": "camionetas",
    },
    {
      "id": 4,
      "name": "Nissan",
      "precio": 450,
      "imagen":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Nuevo_Nissan_Sentra_2023.webp/1200px-Nuevo_Nissan_Sentra_2023.webp.png",
      "descripcion": "",
      "categoria": "camionetas",
    }
    // Agrega los demás autos con sus imágenes, detalles y categorías
    // ...
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
    // Aquí puedes agregar la funcionalidad para añadir el producto al carrito
    print("Producto agregado al carrito: ${_foundAutos[index]['name']}");
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