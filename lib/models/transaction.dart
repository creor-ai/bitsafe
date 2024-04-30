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
      inputs: List<TransactionInput>.from(json['inputs'].map((input) => TransactionInput.fromJson(input))),
      outputs: List<TransactionOutput>.from(json['outputs'].map((output) => TransactionOutput.fromJson(output))),
    );
  }
}

class TransactionInput {
  final String address;
  final double amount;

  TransactionInput({
    required this.address,
    required this.amount,
  });

  factory TransactionInput.fromJson(Map<String, dynamic> json) {
    return TransactionInput(
      address: json['address'],
      amount: json['value'], // Assuming 'value' is the key for input amounts
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
      address: json['address'],
      amount: json['value'], // Assuming 'value' is the key for output amounts
    );
  }
}
