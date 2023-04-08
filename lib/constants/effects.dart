class Effects {
  static const loginPageSensitivity = 10;
  static const homePageSensitivity = 7;
  static const chatPageSensitivity = 5;
  static const maxSensitivity = 10;
  static const animationDuration = 300;

  static const appBarOpacityPrimary = 0.5;
  static const appBarAnimationDuration = 500;

  static const blurNone = 0.0;
  static const blurVeryLight = 2.0;
  static const blurLight = 5.0;
  static const blurMedium = 10.0;
  static const blurHeavy = 30.0;

  static const blackLight = 0.2;
  static const blackMedium = 0.4;
  static const blackHeavy = 0.6;

  static double accelerometerF(double value, int sensitivity) =>
      -maxSensitivity * sensitivity + value * sensitivity;
  static double accelerometerR(double value, int sensitivity) =>
      -maxSensitivity * sensitivity - value * sensitivity;
}

