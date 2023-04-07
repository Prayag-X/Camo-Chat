import 'package:flutter/material.dart';

Size screenSize(context) => MediaQuery.of(context).size;

void nextScreen(context, String pageName) {
  Navigator.pushNamed(context, '/$pageName');
}

void nextScreenReplace(context, String pageName) {
  Navigator.pushReplacementNamed(context, '/$pageName');
}

void nextScreenOnly(context, String pageName) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/$pageName', ModalRoute.withName('/'));
}

void screenPop(context) {
  Navigator.of(context).pop();
}

Color darkenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lightenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

void showSnackBar(context, String message, int duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white
        ),
      ),
      backgroundColor: Colors.black54,
      duration: Duration(seconds: duration),
    ),
  );
}
