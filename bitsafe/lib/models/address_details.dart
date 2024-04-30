class AddressDetails {
  final String address;
  bool isNonceReuseChecked = false;
  bool isNonceReuseVulnerable = false;
  bool isAddressReuseChecked = false;
  bool isAddressReuseVulnerable = false;
  bool isCompromisedLinkChecked = false;
  bool isCompromisedLinkVulnerable = false;
  bool isUnusualPatternsChecked = false;
  bool isUnusualPatternsVulnerable = false;
  bool isDustTransactionsChecked = false;
  bool isDustTransactionsVulnerable = false;

  AddressDetails({
    required this.address,
    this.isNonceReuseChecked = false,
    this.isNonceReuseVulnerable = false,
    this.isAddressReuseChecked = false,
    this.isAddressReuseVulnerable = false,
    this.isCompromisedLinkChecked = false,
    this.isCompromisedLinkVulnerable = false,
    this.isUnusualPatternsChecked = false,
    this.isUnusualPatternsVulnerable = false,
    this.isDustTransactionsChecked = false,
    this.isDustTransactionsVulnerable = false,
  });

  // Update methods for each check type
  void updateNonceReuse(bool isVulnerable) {
    isNonceReuseChecked = true;
    isNonceReuseVulnerable = isVulnerable;
  }

  void updateAddressReuse(bool isVulnerable) {
    isAddressReuseChecked = true;
    isAddressReuseVulnerable = isVulnerable;
  }

  void updateCompromisedLink(bool isVulnerable) {
    isCompromisedLinkChecked = true;
    isCompromisedLinkVulnerable = isVulnerable;
  }

  void updateUnusualPatterns(bool isVulnerable) {
    isUnusualPatternsChecked = true;
    isUnusualPatternsVulnerable = isVulnerable;
  }

  void updateDustTransactions(bool isVulnerable) {
    isDustTransactionsChecked = true;
    isDustTransactionsVulnerable = isVulnerable;
  }

  // Method to check if the address is generally safe based on current checks
  bool isSafe() {
    return !(isNonceReuseVulnerable || isAddressReuseVulnerable || isCompromisedLinkVulnerable || isUnusualPatternsVulnerable || isDustTransactionsVulnerable);
  }
}
