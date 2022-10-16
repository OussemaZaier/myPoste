class Account {
  final int id;
  final String type;

  Account(this.id, this.type);

  static List<Account> accountList() {
    return <Account>[
      Account(1, "e-dinar"),
      Account(2, "smart"),
    ];
  }
}
