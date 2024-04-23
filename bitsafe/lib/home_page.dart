import 'package:flutter/material.dart';
import '../models/address_details.dart';
import '../services/blockchain_service.dart';
import '../services/vulnerability_checks.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  AddressDetails? _addressDetails;

  void _checkAddress() async {
    setState(() {
      _isLoading = true;
      _addressDetails = null; // Reset previous results
    });

    String address = _controller.text;
    if (address.isEmpty) {
      setState(() {
        _isLoading = false;
        _addressDetails = null;
      });
      return;
    }

    try {
      var transactions = await BlockchainService().fetchTransactions(address);
      var details = AddressDetails(address: address);
      VulnerabilityChecks.runAllChecks(transactions, details);

      setState(() {
        _addressDetails = details;
      });
    } catch (e) {
      setState(() {
        _addressDetails = AddressDetails(address: address); // No results found, possibly with error message
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BitSafe Bitcoin Checker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Bitcoin Address',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                ),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onSubmitted: (_) => _checkAddress(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkAddress,
              child: _isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : Text('Check Address'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            SizedBox(height: 20),
            if (_addressDetails != null) ...[
              Text('Results for: ${_addressDetails!.address}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildCheckResultTile('Address Reuse', _addressDetails!.isAddressReuseVulnerable),
              _buildCheckResultTile('Nonce Reuse', _addressDetails!.isNonceReuseVulnerable),
              _buildCheckResultTile('Compromised Link', _addressDetails!.isCompromisedLinkVulnerable),
              _buildCheckResultTile('Unusual Patterns', _addressDetails!.isUnusualPatternsVulnerable),
              _buildCheckResultTile('Dust Transactions', _addressDetails!.isDustTransactionsVulnerable),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCheckResultTile(String checkName, bool isVulnerable) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isVulnerable ? Colors.red : Colors.green,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isVulnerable ? Icons.close : Icons.check,
          color: Colors.white,
          size: 16,
        ),
      ),
      title: Text(checkName),
      trailing: Switch(
        value: !isVulnerable,
        onChanged: (value) {},
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        inactiveTrackColor: Colors.red[200],
      ),
    );
  }
}
