class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "๐บ๐ธ", "English", "en"),
      Language(2, "๐ธ๐ฆ", "ุงูููุนูุฑูุจููููุฉู", "ar"),
      Language(3, "๐ซ๐ท", "franรงais", "fr")
    ];
  }
}
