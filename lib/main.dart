import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Movies App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController input = TextEditingController();
  var desc = "", _poster = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies App')),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: input,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          fillColor: const Color.fromARGB(231, 247, 249, 249),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none),
                          hintText: "Search for movie",
                          prefixIcon: const Icon(Icons.search))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _search,
                    child: const Text("Search"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Image.network(
                    _poster,
                    height: 200,
                    width: 300,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                          height: 200,
                          width: 300,
                          fit: BoxFit.cover,
                          'assets/images/movies.png');
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: const Color.fromARGB(255, 209, 185, 185),
                      child: Column(
                        children: [
                          Text(
                            desc,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _search() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: SizedBox(
                height: 150, width: 150, child: CircularProgressIndicator()));
      },
    );

    /* ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();*/

    String movieName = input.text;
    var apiid = "1d50f6b5";
    var url = Uri.parse(
        'http://www.omdbapi.com/?t=$movieName&apikey=$apiid&units=metric');

    var response = await http.get(url);
    var rescode = response.statusCode;

    
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
if (parsedJson['Title'] != null) {
      setState(() {
        var title = parsedJson['Title'];
        var released = parsedJson['Released'];
        var genre = parsedJson['Genre'];
        var poster = parsedJson['Poster'];
        var plot = parsedJson['Plot'];
        var runtime = parsedJson['Runtime'];
        var language = parsedJson['Language'];
        desc =
            'MOVIE NAME: $title.\n-------------------------------\nRELEASED:$released\nGENRE:$genre  \nRUNETIME:\t $runtime\nLANGUAGE:$language\nPLOTE:\t $plot';
        _poster = '$poster';

        Fluttertoast.showToast(
            msg: "FOUNDS",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color.fromARGB(255, 188, 193, 198),
            fontSize: 25.0);
      });
    }
     if (parsedJson['Title'] == null){
      setState(() {
        desc = "No response";       
        Fluttertoast.showToast(
            msg: "NOT FOUND",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color.fromARGB(255, 188, 193, 198),
            fontSize: 25.0);
      });
    }
    Navigator.of(context).pop();
  }
}
