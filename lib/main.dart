import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//for circular progress indicator

import 'package:pokeapp/pokemon.dart';
import 'package:pokeapp/pokemon_detail.dart';

void main() {
  runApp(MaterialApp(
    title: "Poke App",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));

//stateless widget doesn't change whereas stateful can change
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub? pokeHub;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<PokeHub?> fetchData() async {
    try {
      var res = await http.get(Uri.parse(url));
      print(res);

      var decodedJson = jsonDecode(res.body);

      pokeHub = PokeHub.fromJson(decodedJson);

      return pokeHub;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<PokeHub?>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == null) {
              return Text("data");
            } else {
              return GridView.count(
                crossAxisCount: 2,
                children: snapshot.data!.pokemon!
                    .map((poke) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PokeDetail(
                                            pokemon: poke,
                                          )));
                              //context:location of a particular widget in the widget tree
                            },
                            child: Hero(
                              tag: poke.img,
                              child: Card(
                                elevation: 3.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 100.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(poke.img))),
                                    ),
                                    Text(
                                      poke.name,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
            }
          }
        },
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
