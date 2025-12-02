enum Flavor { dev, release }

class FlavorConfig {
  final Flavor flavor;


  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor}) =>
      _instance ??= FlavorConfig._(flavor: flavor);

  FlavorConfig._({required this.flavor});

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception("Not initialized");
    }

    return _instance!;
  }

  static bool isDev() => instance.flavor == Flavor.dev;

  static bool isProd() => instance.flavor == Flavor.release;
}
