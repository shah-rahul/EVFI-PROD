enum LendingStatus {
  canceled(-2),
  declined(-1),
  charging(0),
  requested(1),
  accepted(2),
  completed(3);

  final int code;

  const LendingStatus(this.code);
}

enum typeCharger {
  Level1,
  Level2,
  Level3,
}

enum ChargerStatus{
  nonAvailable,
  available
}

class AppMargin {
  static const double m2 = 2.0;
  static const double m8 = 8.0;
  static const double m12 = 12.0;
  static const double m14 = 14.0;
  static const double m16 = 16.0;
  static const double m18 = 18.0;
  static const double m20 = 20.0;
  static const double m40 = 40.0;
}

class AppPadding {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p30 = 30.0;
  static const double p40 = 40.0;
  static const double p50 = 50.0;
}

class AppSize {
  static const double s1_5 = 1.5;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s25 = 25.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s60 = 60.0;
  static const double s65 = 65.0;
  static const double s100 = 100.0;
  static const double s200 = 200.0;
}

class DurationConstant {
  static const int d300 = 300;
  static const int d2000 = 2000;
}
