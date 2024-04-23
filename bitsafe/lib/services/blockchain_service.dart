import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class BlockchainService {
  final String baseUrl = 'https://blockstream.info/api/';

  Future<List<Transaction>> fetchTransactions(String address) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}address/$address/txs'));
      if (response.statusCode == 200) {
        List<dynamic> transactionsJson = jsonDecode(response.body);
        return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } on Exception catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
