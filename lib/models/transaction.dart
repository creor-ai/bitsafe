class Transaction {
  final String txid;
  final List<TransactionInput> inputs;
  final List<TransactionOutput> outputs;

  Transaction({
    required this.txid,
    required this.inputs,
    required this.outputs,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      txid: json['txid'],
      inputs: List<TransactionInput>.from(json['vin'].map((input) => TransactionInput.fromJson(input))),
      outputs: List<TransactionOutput>.from(json['vout'].map((output) => TransactionOutput.fromJson(output))),
    );
  }
}

class TransactionInput {
  final String address;
  final double amount;
  final String sigScript; // Assuming this is necessary for nonce reuse checks
  final String prevoutScript;

  TransactionInput({
    required this.address,
    required this.amount,
    required this.sigScript,
    required this.prevoutScript,
  });

  factory TransactionInput.fromJson(Map<String, dynamic> json) {
    return TransactionInput(
      address: json['address'] ?? 'Unknown Address', // Default value if not present
      amount: json['value'] != null ? double.parse(json['value'].toString()) : 0.0, // Default to 0 if not present
      sigScript: json['sigScript'] ?? '', // Default to empty string if not present
      prevoutScript: json['prevout'] != null ? json['prevout']['script'] : '', // Default to empty if not present
    );
  }
}

class TransactionOutput {
  final String address;
  final double amount;

  TransactionOutput({
    required this.address,
    required this.amount,
  });

  factory TransactionOutput.fromJson(Map<String, dynamic> json) {
    return TransactionOutput(
      address: json['address'] ?? 'Unknown Address', // Provide a default value if the address is missing
      amount: json['value'] != null ? double.parse(json['value'].toString()) : 0.0, // Default to 0 if value is missing
    );
  }
}
