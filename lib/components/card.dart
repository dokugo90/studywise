import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../utils/styles.dart';

class FlipCardExample extends StatefulWidget {
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;

          if (_isFlipped) {
            _animationController!.forward();
          } else {
            _animationController!.reverse();
          }
        });
      },
      child: AnimatedBuilder(
        animation: _curvedAnimation!,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.rotationY(_curvedAnimation!.value * 3.14),
            alignment: Alignment.center,
            child: Container(
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
              child: _isFlipped
                  ? Center(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14),
                        child: const Text(
                          'Answer',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Question',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
