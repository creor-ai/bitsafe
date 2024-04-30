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

  void initState() {
    super.initState();
    // Initialize with all checks as not attempted
    _addressDetails = AddressDetails(address: '');
  }

  void _checkAddress() async {
    if (_controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please enter a Bitcoin address to check."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      // Initialize checks as pending with initial false status
      _addressDetails = AddressDetails(address: _controller.text);
    });

    try {
      var transactions = await BlockchainService().fetchTransactions(_controller.text);
      var details = AddressDetails(address: _controller.text);

      // Address Reuse Check
      VulnerabilityChecks.checkAddressReuse(transactions, details);
      setState(() {
        _addressDetails!.isAddressReuseChecked = true;
        _addressDetails!.isAddressReuseVulnerable = details.isAddressReuseVulnerable;
      });

      // Nonce Reuse Check
      VulnerabilityChecks.checkNonceReuse(transactions, details);
      setState(() {
        _addressDetails!.isNonceReuseChecked = true;
        _addressDetails!.isNonceReuseVulnerable = details.isNonceReuseVulnerable;
      });

      // Unusual Patterns Check
      VulnerabilityChecks.checkUnusualPatterns(transactions, details);
      setState(() {
        _addressDetails!.isUnusualPatternsChecked = true;
        _addressDetails!.isUnusualPatternsVulnerable = details.isUnusualPatternsVulnerable;
      });

      // Dust Transactions Check
      VulnerabilityChecks.checkDustTransactions(transactions, details);
      setState(() {
        _addressDetails!.isDustTransactionsChecked = true;
        _addressDetails!.isDustTransactionsVulnerable = details.isDustTransactionsVulnerable;
      });

      // Optionally update the UI after all checks are completed
      setState(() {
        _addressDetails = details;
      });
    } catch (e, stackTrace) {
      // Catch the exception and stack trace for more detailed debugging
      // Log the error and stack trace to the console for debugging
      print('Failed to fetch data: $e');
      print('Stack Trace: $stackTrace');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("We encountered an issue while processing your request. Please try again later."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
        title: Text('BitSafe: Bitcoin Address Checker'),
        backgroundColor: Colors.orangeAccent[700],
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
              child: _isLoading
                  ? SizedBox(
                      height: 20, // Smaller height
                      width: 20, // Smaller width to maintain the circular shape
                      child: CircularProgressIndicator(
                          strokeWidth: 2, // Thinner stroke
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Text('Check Address', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent[700], // Background color of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Set your custom border radius here
                ), // Highly rounded edges, pill shape
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Horizontal padding for wider button appearance
                fixedSize: Size.fromHeight(40), // Set the height of the button
                textStyle: TextStyle(
                  fontSize: 16, // Font size
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_addressDetails != null) ...[
              Text('Results for: ${_addressDetails!.address}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildCheckResultTile('Address Reuse', _addressDetails!.isAddressReuseChecked, _addressDetails!.isAddressReuseVulnerable),
              _buildCheckResultTile('Nonce Reuse', _addressDetails!.isNonceReuseChecked, _addressDetails!.isNonceReuseVulnerable),
              _buildCheckResultTile('Unusual Patterns', _addressDetails!.isUnusualPatternsChecked, _addressDetails!.isUnusualPatternsVulnerable),
              _buildCheckResultTile('Dust Transactions', _addressDetails!.isDustTransactionsChecked, _addressDetails!.isDustTransactionsVulnerable),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCheckResultTile(String checkName, bool isChecked, bool isVulnerable) {
    Color iconColor = isChecked ? (isVulnerable ? Colors.red : Colors.green) : Colors.grey;
    IconData icon = isChecked ? (isVulnerable ? Icons.close : Icons.check) : Icons.hourglass_empty;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: iconColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
      title: Text(checkName),
      subtitle: Text(isChecked ? (isVulnerable ? 'Vulnerable' : 'Safe') : 'Pending'),
    );
  }
}
