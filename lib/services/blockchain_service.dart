import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class BlockchainService {
  final String baseUrl = 'https://blockstream.info/api/';

  Future<List<Transaction>> fetchTransactions(String address, {int maxTransactions = 500}) async {
    List<Transaction> transactions = [];
    String? lastTxid;

    while (true) {
      String url = lastTxid == null ? '${baseUrl}address/$address/txs' : '${baseUrl}address/$address/txs/chain/$lastTxid';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> newTransactionsJson = jsonDecode(response.body);
        if (newTransactionsJson.isEmpty) {
          break; // Exit the loop if no more transactions are returned
        }

        List<Transaction> newTransactions = newTransactionsJson.map((json) => Transaction.fromJson(json)).toList();
        transactions.addAll(newTransactions);

        if (transactions.length >= maxTransactions) {
          transactions = transactions.sublist(0, maxTransactions);
          break; // Stop fetching more transactions if the limit is reached
        }

        lastTxid = newTransactions.last.txid; // Set lastTxid to the last transaction in the new batch
      } else {
        throw Exception('Failed to load transactions with status code: ${response.statusCode}');
      }
    }

    return transactions;
  }
}
