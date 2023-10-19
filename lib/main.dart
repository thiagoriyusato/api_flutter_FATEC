import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'class_model.dart';

final String url = 'https://www.dnd5eapi.co';

Future<DndClass> fetchDndClass(String itemUrl) async {
  final response = await http.get(Uri.parse('$url/api/classes/$itemUrl'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DndClass.fromJson(data);
  } else {
    throw Exception('Failed to load class data');
  }
}

Future<Proficiency> fetchDndProficiency(String itemUrl) async {
  final response = await http.get(Uri.parse('$url$itemUrl'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Proficiency.fromJson(data);
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 148, 0, 0),
                  Color.fromARGB(255, 56, 0, 0)
                ]),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('../assets/background-theme.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            bottom: 110, // Fixar na parte inferior
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(225, 204, 14, 0),
                    Color.fromARGB(225, 90, 8, 0),
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color.fromARGB(255, 158, 18, 18),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/class_list');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 68, 0, 0)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(200, 50)),
                    ),
                    child: const Text(
                      'List of Classes',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/other_endpoints');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 68, 0, 0)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(200, 50)),
                    ),
                    child: const Text(
                      'Other Endpoints',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                                              child: Text('${option.item.name}',
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
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            title: const Text(
                                                'Proficiency Details'),
                                            content: DndProficiencyDetail(
                                                itemUrl: proficiency.url),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Close'),
                                                child: const Text('Close'),
                                              )
                                            ],
                                          )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text('Name: ${proficiency.name}'),
                                    ],
                                  ),
                                ),
                              )
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
                      if (dndClass.subclasses != null)
                        ExpansionTile(
                          title: Text('Subclasses', textAlign: TextAlign.left),
                          children: [
                            for (var subclass in dndClass.subclasses!)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Subclass Name: ${subclass.name}'),
                                    Text('Subclass Index: ${subclass.index}'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (dndClass.spellcasting != null)
                        ExpansionTile(
                          title:
                              Text('Spellcasting', textAlign: TextAlign.left),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      'Spellcasting Level: ${dndClass.spellcasting?.level.toString()}'),
                                  SizedBox(
                                      height:
                                          8.0), // Espaço vertical entre os itens
                                  Text(
                                      'Spellcasting Ability: ${dndClass.spellcasting?.spellcastingAbility.name}'),
                                  SizedBox(
                                      height:
                                          8.0), // Espaço vertical entre os itens
                                  for (var spellcastingInfo
                                      in dndClass.spellcasting!.info)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Name: ${spellcastingInfo.name}'),
                                        for (var desc in spellcastingInfo.desc)
                                          Text(desc),
                                        SizedBox(
                                            height:
                                                8.0), // Espaço vertical entre os itens
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
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

class DndProficiencyDetail extends StatelessWidget {
  final String itemUrl;

  const DndProficiencyDetail({super.key, required this.itemUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Proficiency>(
      future: fetchDndProficiency(itemUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final dndClass = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${dndClass.name}'),
              Text('Type: ${dndClass.type}'),
            ],
          );
        }
      },
    );
  }
}
