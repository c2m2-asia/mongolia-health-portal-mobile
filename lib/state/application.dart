import 'dart:ui';

typedef void LocaleChangeCallback(Locale locale);

class Application {
  // List of supported languages
  final List<String> supportedLanguages = ['en', 'mn'];

  // Supported Locales list
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // method called when the language changes
  LocaleChangeCallback onLocaleChanged;

  ///
  /// Internals
  ///
  static final Application _application = new Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();
}

Application application = new Application();
