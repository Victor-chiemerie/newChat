import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.all(25),
        ),
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ));
  }
}
