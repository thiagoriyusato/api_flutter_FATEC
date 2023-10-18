import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'class_model.dart';

Future<DndClass> fetchDndClass(String itemUrl) async {
  final response =
      await http.get(Uri.parse('https://www.dnd5eapi.co/api/classes/$itemUrl'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DndClass.fromJson(data);
  } else {
    throw Exception('Failed to load class data');
  }
}

Future<List<DndApiItem>> consultarClasses(String endpoint) async {
  final response =
      await http.get(Uri.parse('https://www.dnd5eapi.co/api/$endpoint'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final items = List<Map<String, dynamic>>.from(data['results']);
    return items.map((item) => DndApiItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load API data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D Class App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/class_list': (context) => const DndClassListScreen(),
        '/other_endpoints': (context) => const OtherEndpointsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D&D API Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/class_list');
              },
              child: const Text('List of Classes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/other_endpoints');
              },
              child: const Text('Other Endpoints'),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherEndpointsScreen extends StatelessWidget {
  const OtherEndpointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Endpoints'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implementação para acessar outros endpoints da API
              },
              child: const Text('Endpoint 1'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementação para acessar outros endpoints da API
              },
              child: const Text('Endpoint 2'),
            ),
            // Adicione mais botões conforme necessário
          ],
        ),
      ),
    );
  }
}

class DndClassMenuScreen extends StatelessWidget {
  const DndClassMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D&D API Menu'),
      ),
      body: Center(
        child: FutureBuilder<List<DndApiItem>>(
          future: consultarClasses('classes'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final apiItems = snapshot.data!;
              return ListView.builder(
                itemCount: apiItems.length,
                itemBuilder: (context, index) {
                  final item = apiItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DndClassDetailScreen(classUrl: item.url),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DndClassDetailScreen extends StatelessWidget {
  final String classUrl;

  const DndClassDetailScreen({super.key, required this.classUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Detail'),
      ),
      body: Center(
        child: FutureBuilder<DndClass>(
          future: fetchDndClass(classUrl.split('/').last),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final dndClass = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class Name: ${dndClass.name}',
                          textAlign: TextAlign.left),
                      Text('Hit Die: ${dndClass.hitDie.toString()}',
                          textAlign: TextAlign.left),
                      Text('Index: ${dndClass.index.toString()}',
                          textAlign: TextAlign.left),
                      dndClass.spells != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Spells: ${dndClass.spells}',
                                  textAlign: TextAlign.left),
                            )
                          : const SizedBox.shrink(),
                      if (dndClass.proficiencyChoices != null)
                        ExpansionTile(
                          title: Text('Proficiency Choices',
                              textAlign: TextAlign.left),
                          children: [
                            for (var proficiencyChoice
                                in dndClass.proficiencyChoices!)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                        'Description: ${proficiencyChoice.desc}',
                                        textAlign: TextAlign.left),
                                    Text(
                                        'Choose: ${proficiencyChoice.choose.toString()}',
                                        textAlign: TextAlign.left),
                                    Text('Type: ${proficiencyChoice.type}',
                                        textAlign: TextAlign.left),
                                    if (proficiencyChoice.from != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Options:',
                                              textAlign: TextAlign.left),
                                          for (var option
                                              in proficiencyChoice.from!)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 16.0),
                                              child: Text(
                                                  'Item Name: ${option.item.name}',
                                                  textAlign: TextAlign.left),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (dndClass.proficiencies != null)
                        ExpansionTile(
                          title:
                              Text('Proficiencies', textAlign: TextAlign.left),
                          children: [
                            for (var proficiency in dndClass.proficiencies!)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Name: ${proficiency.name}'),
                                    Text('url: ${proficiency.url}'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (dndClass.savingThrows != null)
                        ExpansionTile(
                          title:
                              Text('Saving throws', textAlign: TextAlign.left),
                          children: [
                            for (var savingThrow in dndClass.savingThrows!)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Name: ${savingThrow.name}'),
                                    Text('url: ${savingThrow.url}'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (dndClass.startingEquipment != null)
                        ExpansionTile(
                          title: Text('Starting Equipment',
                              textAlign: TextAlign.left),
                          children: [
                            for (var equipment in dndClass.startingEquipment!)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                        'Equipment Name: ${equipment.equipment.name}'),
                                    Text(
                                        'Quantity: ${equipment.quantity.toString()}'),
                                    Text(
                                        'Equipment URL: ${equipment.equipment.url}'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DndClassListScreen extends StatelessWidget {
  const DndClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D&D Classes'),
      ),
      body: Center(
        child: FutureBuilder<List<DndApiItem>>(
          future: consultarClasses(
              'classes'), //método consulta as classes do endpoint
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading enquanto o Endpoint retorna os dados.
            } else {
              final apiItems = snapshot.data!;
              return ListView.builder(
                itemCount: apiItems.length,
                itemBuilder: (context, index) {
                  final item = apiItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DndClassDetailScreen(classUrl: item.index),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DndItemDetailScreen extends StatelessWidget {
  final String itemUrl;

  const DndItemDetailScreen({super.key, required this.itemUrl});

  @override
  Widget build(BuildContext context) {
    // Aqui você pode fazer a requisição usando a URL do item e exibir os detalhes.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
      ),
      body: Center(
        child: FutureBuilder<DndClass>(
          future: fetchDndClass(itemUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final dndClass = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Class Name: ${dndClass.name}'),
                  Text('Hit Points: ${dndClass.index}'),
                  Text('Hit Dice: ${dndClass.hitDie}'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
