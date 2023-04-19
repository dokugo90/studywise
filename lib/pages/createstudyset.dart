import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:studywise/components/widgets.dart';
import 'package:studywise/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/sets.dart';

class CreateStudySet extends StatefulWidget {
  const CreateStudySet({super.key});

  @override
  State<CreateStudySet> createState() => _CreateStudySetState();
}

class _CreateStudySetState extends State<CreateStudySet> with ChangeNotifier {
  final bool theme = GetIt.instance.get<ThemeService>().darkMode;
  TextEditingController setName = TextEditingController();
  TextEditingController setDescription = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var uuid = Uuid();

  @override
  void dispose() {
    setName.dispose();
    setDescription.dispose();
    super.dispose();
  }

  String getFormattedDate() {
    DateTime createdDate = DateTime.now();
    Duration difference = DateTime.now().difference(createdDate);
    if (difference.inDays < 1) {
      return 'Created today';
    } else if (difference.inDays < 2) {
      return 'Created yesterday';
    } else if (difference.inDays < 7) {
      return 'Created ${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return 'Created ${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays < 365) {
      return 'Created ${difference.inDays ~/ 30} months ago';
    } else {
      return 'Created ${difference.inDays ~/ 365} years ago';
    }
  }

  void createSet() async {
    var v4 = uuid.v4();
    var prefs = await _prefs;
    //String termsJsonStr = json.encode(terms);
    Map setInfo = {
      "name": setName.text,
      "description": setDescription.text,
      "dateCreated": getFormattedDate(),
      "cardsAmount": terms.length,
      "uuid": v4
    };
    //String setInfoStr = json.encode(setInfo);
    await prefs.setString('$v4', json.encode(terms)).then((value) {
      // Navigator.pop(context);
      var studySetsStr = prefs.getString('studySets');
      var studySets = (studySetsStr != null) ? json.decode(studySetsStr) : [];

      studySets.add(setInfo);

      prefs.setString('studySets', json.encode(studySets));
      //print(prefs.getString('$v4'));
      var decodeStudysets = prefs.getString("studySets") != null
          ? json.decode(prefs.getString('studySets')!)
          : [];
      Provider.of<Sets>(context, listen: false).setStudySets(decodeStudysets);

      Navigator.pop(context);
    });
  }

  List terms = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      terms = [
        {"term": "", "definition": ""},
        {"term": "", "definition": ""},
        {"term": "", "definition": ""},
        {"term": "", "definition": ""},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Study Set",
          style: TextStyle(
              color: GetIt.instance.get<ThemeService>().darkMode == true
                  ? Colors.white
                  : Colors.black,
              fontWeight: fontBold),
        ),
        elevation: 0,
        backgroundColor: theme ? darkTheme : lightTheme,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: GetIt.instance.get<ThemeService>().darkMode == true
                  ? Colors.white
                  : Colors.black,
            )),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:
              BoxDecoration(color: theme == true ? darkTheme : lightTheme),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                PrimaryTextField(
                    controller: setName,
                    onChanged: (value) {
                      setState(() {
                        setName.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: value.length),
                          ),
                        );
                      });
                    },
                    hintColor:
                        GetIt.instance.get<ThemeService>().darkMode == true
                            ? Colors.white
                            : Colors.black,
                    fillColor:
                        GetIt.instance.get<ThemeService>().darkMode == true
                            ? darkThemeUi
                            : lightThemeUi,
                    hintText: "Study Set Name"),
                const SizedBox(
                  height: 20,
                ),
                PrimaryTextField(
                    controller: setDescription,
                    onChanged: (value) {
                      setState(() {
                        setDescription.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: value.length),
                          ),
                        );
                      });
                    },
                    hintColor:
                        GetIt.instance.get<ThemeService>().darkMode == true
                            ? Colors.white
                            : Colors.black,
                    fillColor:
                        GetIt.instance.get<ThemeService>().darkMode == true
                            ? darkThemeUi
                            : lightThemeUi,
                    hintText: "Study Set Description"),
                Expanded(
                  child: ListView.builder(
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 3),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Card ${index + 1}",
                                      style: TextStyle(
                                          color: GetIt.instance
                                                      .get<ThemeService>()
                                                      .darkMode ==
                                                  true
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: fontBold,
                                          fontSize: 17),
                                    ),
                                    Expanded(child: Container()),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            print(
                                                'Removing item at index $index'); // Add debug print statement
                                            terms.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          EvaIcons.trash2Outline,
                                          color: Colors.red,
                                        ))
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: PrimaryTextField(
                                    onChanged: (value) {
                                      setState(() {
                                        terms[index]["term"] = value;
                                      });
                                    },
                                    hintColor: GetIt.instance
                                                .get<ThemeService>()
                                                .darkMode ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                    fillColor: GetIt.instance
                                                .get<ThemeService>()
                                                .darkMode ==
                                            true
                                        ? darkThemeUi
                                        : lightThemeUi,
                                    hintText: "Term"),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: GetIt.instance
                                            .get<ThemeService>()
                                            .darkMode ==
                                        true
                                    ? darkThemeUi
                                    : lightThemeUi,
                              ),
                              Expanded(
                                child: PrimaryTextField(
                                    onChanged: (value) {
                                      setState(() {
                                        terms[index]["definition"] = value;
                                      });
                                    },
                                    hintColor: GetIt.instance
                                                .get<ThemeService>()
                                                .darkMode ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                    fillColor: GetIt.instance
                                                .get<ThemeService>()
                                                .darkMode ==
                                            true
                                        ? darkThemeUi
                                        : lightThemeUi,
                                    hintText: "Definition"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      terms.add({"term": "", "definition": ""});
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Card",
                        style: TextStyle(
                            color:
                                GetIt.instance.get<ThemeService>().darkMode ==
                                        true
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 16,
                            fontWeight: fontBold),
                      ),
                      Icon(
                        EvaIcons.plus,
                        size: 20,
                        color:
                            GetIt.instance.get<ThemeService>().darkMode == true
                                ? Colors.white
                                : Colors.black,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: createSet,
          tooltip: 'Create',
          child: Icon(
            EvaIcons.plus,
            color: lightTheme,
          )),
    ));
  }
}
