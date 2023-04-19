import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:studywise/components/card.dart';
import 'package:studywise/components/widgets.dart';
import 'package:studywise/pages/createstudyset.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sets.dart';
import '../utils/styles.dart';
import 'display_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int setsAmount = 0;
  bool darkMode = GetIt.instance.get<ThemeService>().darkMode;
  List studySets = [], filteredItems = [];

  void getAllStudySets() async {
    var prefs = await _prefs;
    setState(() {
      var decodeStudysets = prefs.getString("studySets") != null
          ? json.decode(prefs.getString('studySets')!)
          : [];
      Provider.of<Sets>(context, listen: false).setStudySets(decodeStudysets);
      studySets = Provider.of<Sets>(context, listen: false).allSets;
      filteredItems = studySets;
    });
  }

  void deleteAllStudySets() async {
    var prefs = await _prefs;
    await prefs.remove("studySets").then(
        (_) => {Provider.of<Sets>(context, listen: false).setStudySets([])});
  }

  void deleteStudySet(int index, String uuid) async {
    var prefs = await _prefs;

    // Decode the JSON string to a dynamic object
    dynamic decodedData = json.decode(prefs.getString('studySets')!) ?? [];

    // Check that the decoded data is a list
    if (decodedData is List<dynamic>) {
      // Remove the item at the specified index
      decodedData.removeAt(index);
    }

    // Encode the modified data back to a JSON string
    String encodedData = json.encode(decodedData);

    // Update the value of the 'studySets' key in SharedPreferences
    await prefs.setString('studySets', encodedData).then((_) async {
      await prefs.remove(uuid);
    });

    Provider.of<Sets>(context, listen: false).setStudySets(decodedData);
  }

  void handleTheme() async {
    var prefs = await _prefs;
    var theme = prefs.getBool("darkMode");
    if (theme == null) {
      setState(() {
        GetIt.instance.get<ThemeService>().darkMode = true;
        darkMode = true;
      });
      prefs.setBool("darkMode", true);
    } else {
      if (theme == true) {
        setState(() {
          GetIt.instance.get<ThemeService>().darkMode = false;
          darkMode = false;
        });
        prefs.setBool("darkMode", false);
      } else {
        setState(() {
          GetIt.instance.get<ThemeService>().darkMode = true;
          darkMode = true;
        });
        prefs.setBool("darkMode", true);
      }
    }
  }

  void getTheme() async {
    var prefs = await _prefs;
    var theme = prefs.getBool("darkMode");

    if (theme != null) {
      setState(() {
        GetIt.instance.get<ThemeService>().darkMode = theme;
        darkMode = theme;
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    getAllStudySets();

    getTheme();

    //print(Provider.of<Sets>(context, listen: false).allSets);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Studywise",
          style: TextStyle(
              fontWeight: fontBold,
              fontSize: 24,
              color: darkMode == true ? Colors.white : Colors.black),
        ),
        centerTitle: false,
        backgroundColor: darkMode == true ? darkTheme : lightTheme,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: darkMode == true ? light_mode_icon : dark_mode_icon,
              splashColor: Colors.white,
              tooltip: darkMode == true ? "Light Mode" : "Dark Mode",
              onPressed: handleTheme,
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:
              BoxDecoration(color: darkMode == true ? darkTheme : lightTheme),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Welcome, get stared studying 📚.",
                          style: TextStyle(
                              color: darkMode == true
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: PrimaryTextField(
                        onChanged: (value) {
                          setState(() {
                            Provider.of<Sets>(context, listen: false)
                                .setStudySets(studySets
                                    .where((studySet) => studySet["name"]
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList());
                          });
                        },
                        fillColor:
                            darkMode == true ? darkThemeUi : Colors.white,
                        hintColor:
                            darkMode == true ? Colors.white : Colors.black,
                        hintText: "Search your study sets")),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40, left: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<Sets>(builder: (context, sets, child) {
                        return Text(
                          "Sets (${sets.allSets.length})",
                          style: TextStyle(
                              color: darkMode == true
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: fontBold,
                              fontSize: 17),
                        );
                      }),
                      Expanded(child: Container()),
                      InkWell(
                          onTap: deleteAllStudySets,
                          child: Text("delete all",
                              style: TextStyle(
                                  color: darkMode == true
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: fontBold,
                                  fontSize: 17))),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Consumer<Sets>(builder: (context, sets, child) {
                      return ListView.builder(
                        itemCount: sets.allSets.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 80, right: 80, bottom: 30),
                            child: GestureDetector(
                              onTap: () async {
                                /*var prefs = await _prefs;
                                var cards = prefs.getString(
                                    '${sets.allSets[index]["uuid"]}');
                                print(cards);*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayCards(
                                        setName: sets.allSets[index]["name"],
                                        setDescription: sets.allSets[index]["description"],
                                        setUuid: sets.allSets[index]["uuid"],
                                      ),
                                    ));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.5), // Set the color of the shadow
                                        spreadRadius:
                                            2, // Set the spread radius of the shadow
                                        blurRadius:
                                            5, // Set the blur radius of the shadow
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(25),
                                    color: darkMode == true
                                        ? darkThemeUi
                                        : lightThemeUi),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            sets.allSets[index]["name"]
                                                .toString(),
                                            style: TextStyle(
                                                color: darkMode == true
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Container(
                                            width: 5,
                                            height: 5,
                                            
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    8), // Add some space around the dot
                                            decoration: const BoxDecoration(
                                              color: Colors
                                                  .grey, // Set the color of the dot
                                              shape: BoxShape
                                                  .circle, // Set the shape to a circle
                                            ),
                                          ),
                                          Text(
                                            "${sets.allSets[index]["cardsAmount"]} Cards",
                                            style: TextStyle(
                                                color: darkMode == true
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Expanded(child: Container()),
                                          PopupMenuButton(
                                            icon: Icon(
                                              EvaIcons.moreHorizontal,
                                              color: darkMode == true
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            tooltip: 'Options',
                                            itemBuilder: (context) {
                                              return [
                                                const PopupMenuItem(
                                                  child: Text('Edit'),
                                                  value: 'edit',
                                                ),
                                                const PopupMenuItem(
                                                  child: Text('Delete'),
                                                  value: 'delete',
                                                ),
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == "delete") {
                                                deleteStudySet(
                                                    index,
                                                    sets.allSets[index]
                                                        ["uuid"]);
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        "${sets.allSets[index]["dateCreated"]}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateStudySet()),
            );
          },
          tooltip: 'Create New Study Set',
          child: Icon(
            EvaIcons.plus,
            color: lightTheme,
          )),
    ));
  }
}

/* child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            EvaIcons.moreHorizontal,
                                            color: darkMode == true
                                                ? Colors.white
                                                : Colors.black,
                                          )), */

/* 
createDeck() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: mainColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Create a new study set",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Set name',
                        hintStyle: TextStyle(
                            color:
                                darkMode == true ? Colors.white : Colors.black,
                            fontSize: 17),
                        filled: true,
                        fillColor:
                            darkMode == true ? Colors.black : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: const Color(0xFF4636FC),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Set name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          newSetName = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Set description',
                        hintStyle: TextStyle(
                            color:
                                darkMode == true ? Colors.white : Colors.black,
                            fontSize: 17),
                        filled: true,
                        fillColor:
                            darkMode == true ? Colors.black : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: mainColor,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Set description cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          newSetDescription = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         _formKey.currentState!.save();
                          // Do something with the form data
                          //StorageFactory().setItem('test', 'yo man');
                          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => CreateStudySet(setName: newSetName, setDescription: newSetDescription)),
);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            darkMode == true ? Colors.black : Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Create",
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.add,
                            color: mainColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
*/
