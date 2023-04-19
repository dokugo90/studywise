import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sets extends ChangeNotifier {
  List studySets = [];
  List filterdStudySets = [];

  List get allSets => studySets;

  void setStudySets(List newStudySets) {
    studySets = newStudySets;
    notifyListeners();
  }
}