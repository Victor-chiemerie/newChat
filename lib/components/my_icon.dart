import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
    final IconData iconData;
    final Color backgroundColor;

    const RoundIconButton({required this.iconData, required this.backgroundColor});

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    iconData,
                    color: Colors.white, // Set icon color (usually white for contrast)
                ),
            ),
        );
    }
}
