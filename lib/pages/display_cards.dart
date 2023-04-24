import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_start/slide_to_start.dart';
import 'package:studywise/utils/styles.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

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
  CardSwiperController _cardSwiperController = CardSwiperController();
  bool canSwipe = true;

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
        title: Text("${widget.setName}", style: TextStyle(color: GetIt.instance.get<ThemeService>().darkMode == true
            ? Colors.white
            : Colors.black, fontWeight: FontWeight.w900),),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: GetIt.instance.get<ThemeService>().darkMode == true
            ? Colors.white
            : Colors.black)),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.setDescription.toString(), style: TextStyle(color: GetIt.instance.get<ThemeService>().darkMode == true
            ? Colors.white
            : Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                Expanded(child: Container()),
                Text("Terms in this set (${cards.length})", style: TextStyle(color: GetIt.instance.get<ThemeService>().darkMode == true
            ? Colors.white
            : Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                Expanded(child: Container()),
                Container(
                  height: 350,
                  width: 350,
                  child: Flexible(
                    child: CardSwiper(
                      controller: _cardSwiperController,
                      cardsCount: cards.length,
                      isLoop: false,
                      isDisabled: true,
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (previousIndex == cards.length - 1) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      numberOfCardsDisplayed: cards.length,
                      cardBuilder: (context, index) {
                        return FlipCardExample(
                          term: cards[index]["term"],
                          definition: cards[index]["definition"],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                          backgroundColor: mainColor,
                          onPressed: () {
                            _cardSwiperController.undo();
                            //_cardSwiperController.notifyListeners();
                          },
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
                          onPressed: () {
                            _cardSwiperController.swipeRight();
                            //_cardSwiperController.notifyListeners();
                          },
                          tooltip: 'Next Card',
                          child: Icon(
                            EvaIcons.arrowForward,
                            color: lightThemeUi,
                          )),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SlideToStart(
                  text: "Slide To Start Quiz",
                  
                  shimmerBaseColor: Colors.white,
                  shimmerHighLightColor: Colors.grey,
                  backgroundColor: mainColor,
                  slideButtonColor: Colors.white,
                  iconColor: mainColor,
                  dashButtonBorderColor: Colors.white,
                  onSlide: () {
                    
                  }),
                ),

              ],
            ),
          ),
        ),
      ),
    ));
  }
}
