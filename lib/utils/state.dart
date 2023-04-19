import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:studywise/pages/homepage.dart';
import 'package:studywise/utils/styles.dart';

import '../models/sets.dart';

GetIt locator = GetIt.instance;

void setup() {
  GetIt.instance.registerSingleton<Sets>(Sets());
  GetIt.instance.registerSingleton<ThemeService>(ThemeService());
}
