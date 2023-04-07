import 'package:flutter/material.dart';

class LogoShower extends StatelessWidget {
  const LogoShower({
    Key? key,
    required this.logo,
    required this.size,
  }) : super(key: key);

  final String logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logo),
        ),
      ),
    );
  }
}
