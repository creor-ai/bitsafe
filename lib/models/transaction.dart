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
      txid: json['txid'] as String,
      inputs: (json['vin'] as List).map((i) => TransactionInput.fromJson(i as Map<String, dynamic>)).toList(),
      outputs: (json['vout'] as List).map((o) => TransactionOutput.fromJson(o as Map<String, dynamic>)).toList(),
    );
  }
}

class TransactionInput {
  final String txid;
  final int vout;
  final String sigScript;
  final String prevoutScript;
  final String address;
  final double amount;

  TransactionInput({
    required this.txid,
    required this.vout,
    required this.sigScript,
    required this.prevoutScript,
    required this.address,
    required this.amount,
  });

  factory TransactionInput.fromJson(Map<String, dynamic> json) {
    var prevout = json['prevout'] as Map<String, dynamic>?;
    return TransactionInput(
      txid: json['txid'] as String? ?? 'Unknown TxID',
      vout: json['vout'] as int? ?? 0,
      sigScript: json['scriptsig'] as String? ?? '',
      prevoutScript: prevout != null ? (prevout['scriptpubkey'] as String? ?? '') : '',
      address: prevout != null ? (prevout['scriptpubkey_address'] as String? ?? 'Unknown Address') : 'Unknown Address',
      amount: prevout != null ? (prevout['value'] as num?)?.toDouble() ?? 0.0 : 0.0,
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
      address: json['scriptpubkey_address'] as String? ?? 'Unknown Address',
      amount: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
