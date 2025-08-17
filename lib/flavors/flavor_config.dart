enum Flavor { dev, release }

class FlavorConfig {
  final Flavor flavor;
  final String name;

  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor, required String name}) =>
      _instance ??= FlavorConfig._(flavor: flavor, name: name);

  FlavorConfig._({required this.flavor, required this.name});

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception("Not initialized");
    }

    return _instance!;
  }

  static bool isDev() => instance.flavor == Flavor.dev;

  static bool isProd() => instance.flavor == Flavor.release;
}
