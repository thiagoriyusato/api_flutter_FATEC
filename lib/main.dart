import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'class_model.dart';

enum Swipe { left, right, none }

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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Class Name: ${dndClass.name}'),
                  Text('Hit Die: ${dndClass.hitDie.toString()}'),
                  Text('Index: ${dndClass.index.toString()}'),
                  dndClass.spells != null
                      ? Text('Spells: ${dndClass.spells}')
                      : const SizedBox.shrink(),
                  if (dndClass.proficiencyChoices != null)
                    ExpansionTile(
                      title: Text('Proficiency Choices'),
                      children: [
                        for (var choice in dndClass.proficiencyChoices!)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Description: ${choice.desc}'),
                              Text('Choose: ${choice.choose.toString()}'),
                              Text('Type: ${choice.type}'),
                              if (choice.from != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Options:'),
                                    for (var option in choice.from!)
                                      Text('Item Name: ${option.item.name}'),
                                  ],
                                ),
                            ],
                          ),
                      ],
                    ),
                ],
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
              return const CircularProgressIndicator();
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
