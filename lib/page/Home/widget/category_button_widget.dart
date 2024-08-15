import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CategoryButtonWidget extends StatelessWidget {
  final String? categoryText;
  final String? categoryColor;
  final Function()? onTap;
  const CategoryButtonWidget({
    super.key,
    this.categoryText = 'Book Apon',
    this.onTap,
    this.categoryColor = "#f2f2f2",
  });

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // not remove this
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(categoryColor!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: AutoSizeText(
              minFontSize: 15,
              maxFontSize: 20,
              categoryText!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
