import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.selectedIndex,
    required this.length,
  });

  final int selectedIndex;
  final int length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 150),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(index == selectedIndex ? 1 : .3),
                borderRadius: BorderRadius.circular(7),
                boxShadow: index == selectedIndex
                    ? const [
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 0))
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
