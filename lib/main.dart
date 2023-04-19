import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studywise/pages/display_cards.dart';
import 'package:studywise/pages/homepage.dart';
import 'package:studywise/utils/state.dart';
import 'package:get_it/get_it.dart';
import 'package:studywise/utils/styles.dart';

import 'components/card.dart';
import 'models/sets.dart';

void main() {
  setup();
  setInstances();
  runApp(
    ChangeNotifierProvider (
      create: (_) => Sets(),
      child: const MyApp())
      );
}

void setInstances() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var prefs = await _prefs;
  var decodeStudysets = prefs.getString("studySets") != null
          ? json.decode(prefs.getString('studySets')!)
          : [];
  GetIt.instance.get<Sets>().studySets = decodeStudysets;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
