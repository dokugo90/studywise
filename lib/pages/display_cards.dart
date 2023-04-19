import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studywise/utils/styles.dart';

import '../components/card.dart';

class DisplayCards extends StatefulWidget {
  String setName;
  String setDescription;
  String setUuid;
  DisplayCards(
      {super.key,
      required this.setName,
      required this.setDescription,
      required this.setUuid});

  @override
  State<DisplayCards> createState() => _DisplayCardsState();
}

class _DisplayCardsState extends State<DisplayCards> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List cards = [];

  void getCards() async {
    var prefs = await _prefs;

    var decodeCards = json.decode(prefs.getString('${widget.setUuid}') ?? "");
    setState(() {
      cards = decodeCards;
    });
  }

  @override
  void initState() {
    super.initState();

    getCards();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: GetIt.instance.get<ThemeService>().darkMode == true
            ? darkTheme
            : lightTheme,
        elevation: 0,
        title: Text("${widget.setName}"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: GetIt.instance.get<ThemeService>().darkMode == true
                ? darkTheme
                : lightTheme),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Study Time"),
                Container(
                  width: 300,
                  height: 300,
                  child: Row(
                    children: [
                      ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          return FlipCardExample();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                          backgroundColor: mainColor,
                          onPressed: () {},
                          tooltip: 'Previous Card',
                          child: Icon(
                            EvaIcons.arrowBack,
                            color: lightThemeUi,
                          )),
                      const SizedBox(
                        width: 25,
                      ),
                      FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {},
                          tooltip: 'Delete Card',
                          child: Icon(
                            EvaIcons.trash2Outline,
                            color: lightThemeUi,
                          )),
                      const SizedBox(
                        width: 25,
                      ),
                      FloatingActionButton(
                          backgroundColor: mainColor,
                          onPressed: () {},
                          tooltip: 'Next Card',
                          child: Icon(
                            EvaIcons.arrowForward,
                            color: lightThemeUi,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
