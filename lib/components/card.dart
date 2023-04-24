import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flip_card/flip_card.dart';

import '../utils/styles.dart';

class FlipCardExample extends StatefulWidget {
  String term;
  String definition;
  FlipCardExample(
      {super.key,
      required this.term,
      required this.definition});
  @override
  _FlipCardExampleState createState() => _FlipCardExampleState();
}

class _FlipCardExampleState extends State<FlipCardExample>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  AnimationController? _animationController;
  Animation<double>? _curvedAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      side: _isFlipped ? CardSide.BACK : CardSide.FRONT,
      front: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: GetIt.instance.get<ThemeService>().darkMode == true
              ? darkThemeUi
              : lightThemeUi,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.term.toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      back: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: GetIt.instance.get<ThemeService>().darkMode == true
              ? darkThemeUi
              : lightThemeUi,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.definition.toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      onFlip: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
    );
  }
}

/* 
Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
    color: GetIt.instance.get<ThemeService>().darkMode == true ? darkThemeUi : lightThemeUi,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
    ],
    ),
    child: GestureDetector(
      child: FlipCard(
      fill: Fill.fillBack, 
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: Container(
        child: Center(
          child: Text('Front'),
        ),
      ),
      back: Container(
        child: Center(
          child: Text('Back'),
        ),
      ),
      ),
    ),
  ),
*/
