import 'dart:async';
import 'dart:math';

import 'package:custom_carosel/card_data.dart';
import 'package:custom_carosel/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CigCarousel extends StatefulWidget {
  const CigCarousel({super.key, this.children = const []});

  final List<Widget> children;

  @override
  State<CigCarousel> createState() => _CigCarouselState();
}

class _CigCarouselState extends State<CigCarousel>
    with TickerProviderStateMixin {
  AnimationController? _frontCardCtrl;
  AnimationController? _frictionCtrl;

  List<CardData> cardData = [];
  double radius = 25.0;

  double angleStep = 0;

  double _dragX = 0;
  double _velocityX = 0;
  double frontAngle = 0;
  double angleOffset = 0;

  Timer? _autoSlideTimer;

  String? id;
  String? name;
  double opacity = 1;

  @override
  void initState() {
    super.initState();

    id = Data.model[Data.pageCurrent].id ?? "XXXX-XXXX-XXXX";
    name = Data.model[Data.pageCurrent].name ?? "No Name";

    cardData = widget.children
        .asMap()
        .map((key, value) => MapEntry(key, CardData(key, value)))
        .values
        .toList();
    angleStep = -(pi * 2) / widget.children.length;

    _frontCardCtrl?.dispose();
    _frontCardCtrl = AnimationController.unbounded(vsync: this);
    _frontCardCtrl?.addListener(() => setState(() {}));

    _frictionCtrl?.dispose();
    _frictionCtrl = AnimationController.unbounded(vsync: this);
    _frictionCtrl?.addListener(() => setState(() {}));

    _autoSlide();
  }

  @override
  void dispose() {
    _frontCardCtrl?.dispose();
    _frictionCtrl?.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CigCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    radius = screenWidth * 0.93 / 3;

    angleOffset = pi / 2 + (-_dragX * .006);
    angleOffset += _frictionCtrl?.value ?? 0;
    angleOffset += _frontCardCtrl?.value ?? 0;

    // positioning cards in a circle
    for (var i = 0; i < cardData.length; ++i) {
      var c = cardData[i];
      double ang = angleOffset + c.idx * angleStep;
      c.angle = ang;
      c.x = cos(ang) * radius;
      c.y = sin(ang) * Data.numItems * 50 - Data.numItems * 15;
      c.z = sin(ang) * radius;
    }

    // sort in Z axis.
    cardData.sort((a, b) => a.z.compareTo(b.z));

    var maxZ = cardData.reduce(
      (curr, next) => curr.z > next.z ? curr : next,
    );

    // transform the cards
    var list = cardData.map((vo) {
      var c = addCard(vo);
      var mt2 = Matrix4.identity();
      mt2.setEntry(3, 2, 0.001);

      // position the card based on x,y,z
      mt2.translate(vo.x * 0.9, vo.y * Data.numItems * 0.15, -vo.z);

      // scale the card based on z position
      double scale = 2 + (vo.z / radius) * 0.1;
      mt2.scale(scale, scale);

      c = Transform(
        alignment: Alignment.center,
        origin: const Offset(0.0, 0.0),
        transform: mt2,
        child: c,
      );

      return c;
    }).toList();

    var tmpOpacity = 0.575 +
        0.425 *
            cardData
                .firstWhere((element) => element.idx == Data.pageCurrent)
                .z /
            radius;

    if (tmpOpacity < 0.4) {
      setState(() {
        opacity = tmpOpacity;
      });
    }

    print("----- OPACITY: " + opacity.toString());

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (e) {
              _frictionCtrl?.stop();
              _frontCardCtrl?.stop();
              _autoSlideTimer?.cancel();
            },
            onPanUpdate: (e) {
              _dragX += e.delta.dx;

              var maxZ = cardData.reduce(
                (curr, next) => curr.z > next.z ? curr : next,
              );
              eventChangePage(maxZ.idx);
              setState(() {});
            },
            onPanEnd: (e) {
              _velocityX = e.velocity.pixelsPerSecond.dx;
              _frictionAnimation();
            },
            onPanCancel: () {
              _autoSlide();
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: list,
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 200,
                    ),
                    child: Column(
                      children: [
                        Text(
                          name ?? "No Name",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "ID: ${Data.formatUid(id!)}",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // PageIndicator(
        //   selectedIndex: maxZ.idx,
        //   length: widget.children.length,
        // ),
      ],
    );
  }

  void _autoSlide() {
    // _autoSlideTimer?.cancel();
    // _autoSlideTimer = Timer(const Duration(seconds: 2), () {
    //   var maxZ = cardData.reduce(
    //     (curr, next) => curr.z > next.z ? curr : next,
    //   );
    //   var nextIdx = (maxZ.idx + 1) % widget.children.length;

    //   eventChangePage(nextIdx);

    //   _frontCardAnimation(
    //     nextIdx,
    //     duration: const Duration(milliseconds: 350),
    //     whenComplete: () {
    //       _autoSlide();
    //     },
    //   );
    // });
  }

  void _frictionAnimation() {
    _dragX = 0;
    _frontCardCtrl?.value = 0;

    var beginAngle = angleOffset - pi / 2;

    var simulate = FrictionSimulation(.00001, beginAngle, -_velocityX * .006);
    _frictionCtrl?.animateWith(simulate).whenComplete(() {
      // re-center the front card
      var maxZ = cardData.reduce(
        (curr, next) => curr.z > next.z ? curr : next,
      );

      eventChangePage(maxZ.idx);

      _frontCardAnimation(maxZ.idx, whenComplete: () {
        _autoSlide();
      });
    });
  }

  void _frontCardAnimation(int idx,
      {Duration duration = const Duration(milliseconds: 1000),
      VoidCallback? whenComplete}) {
    _dragX = 0;
    _frictionCtrl?.value = 0;

    frontAngle = -idx * angleStep;

    var beginAngle = angleOffset - pi / 2;
    // because one point can be expressed by multiple different angles in a trigonometric circle
    // we need to find the closest to the front angle.
    if (beginAngle < frontAngle) {
      while ((frontAngle - beginAngle).abs() > pi) {
        beginAngle += pi * 2;
      }
    } else {
      while ((frontAngle - beginAngle).abs() > pi) {
        beginAngle -= pi * 2;
      }
    }

    Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacity = 1.0;
    });

    // animate the front card to the front angle
    _frontCardCtrl?.value = beginAngle;
    _frontCardCtrl
        ?.animateTo(
          frontAngle,
          duration: duration,
          curve: Curves.easeInOut,
        )
        .whenComplete(() => whenComplete?.call());
  }

  eventChangePage(int index) {
    if (Data.model[Data.pageCurrent].type == 1) {
      Data.model[Data.pageCurrent].videoPlayerController!.pause();
    }

    Data.pageCurrent = index;

    if (Data.model[Data.pageCurrent].type == 1) {
      Data.model[Data.pageCurrent].videoPlayerController!.seekTo(Duration.zero);
      Data.model[Data.pageCurrent].videoPlayerController!.play();
    }

    setState(() {
      id = Data.model[Data.pageCurrent].id ?? "";
      name = Data.model[Data.pageCurrent].name ?? "";
    });
  }

  Widget addCard(CardData vo) {
    var shadowAlpha = ((1 - vo.z / radius) / 2) * .6;
    // var cardAlpha = 0.54 + 0.46 * vo.z / radio;
    var cardAlpha = 0.575 + 0.425 * vo.z / radius;

    Widget c;
    c = Column(
      children: [
        GestureDetector(
          child: Opacity(
            opacity: cardAlpha,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2 + shadowAlpha * .2),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(
                      0,
                      2,
                    ),
                  )
                ],
              ),
              child: vo.widget,
            ),
          ),
        ),
        // Opacity(
        //   opacity: cardAlpha,
        //   child: Container(
        //     margin: const EdgeInsets.only(
        //       top: 200,
        //     ),
        //     child: Column(
        //       children: [
        //         Text(
        //           name ?? "No Name",
        //         ),
        //         Text(
        //           "ID: ${Data.formatUid(id!)}",
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
    return c;
  }
}
