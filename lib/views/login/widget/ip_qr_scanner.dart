import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class IpQRScanner extends StatefulWidget {
  const IpQRScanner({super.key});

  @override
  State<IpQRScanner> createState() => _IpQRScannerState();
}

class _IpQRScannerState extends State<IpQRScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR code du serveur.')),
      body: MobileScanner(onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          Navigator.maybePop<String>(context, barcode.rawValue ?? 'No data in QR');
        }
      }),
    );
  }
}