# BitSafe

BitSafe is a Flutter project designed to enhance the security of Bitcoin transactions by checking potential vulnerabilities associated with Bitcoin addresses.

## Getting Started

This project is a great starting point for anyone interested in developing applications that interact with Bitcoin addresses and transactions.

### Prerequisites

Ensure you have Flutter installed on your development machine. For installation guidance, refer to the [Flutter installation guide](https://docs.flutter.dev/get-started/install).

### Running the Application

To run BitSafe in a development environment, especially if you are targeting web platforms, use the following command:

```bash
flutter run -d chrome
```

This command runs the application in a Chrome browser.

## Features

BitSafe performs a series of checks to evaluate the security of a Bitcoin address. Here are the specific checks:

- **Address Reuse**: Determines if the Bitcoin address has been reused, which can compromise privacy and security.
- **Nonce Reuse**: Checks for the reuse of nonces which can lead to vulnerabilities in cryptographic operations.
- **Unusual Patterns**: Identifies unusual patterns that might indicate fraudulent activities.
- **Dust Transactions**: Detects small amounts of bitcoin sent to an address, potentially part of a dusting attack aimed at de-anonymizing the recipients.

## Resources

For those new to Flutter or mobile development, consider the following resources:

- [Flutter's First App Codelab](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## Documentation

For detailed Flutter development documentation, visit the [Flutter online documentation](https://docs.flutter.dev/) which provides tutorials, sample code, guidance on mobile development, and a full API reference.
