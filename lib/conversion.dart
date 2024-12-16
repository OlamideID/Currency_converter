import 'package:flutter/material.dart';

class ConversionResult extends StatelessWidget {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final double total;
  final String lastUpdate;

  const ConversionResult({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.total,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$fromCurrency to $toCurrency = $rate',
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(height: 20),
        if (total != 0.0)
          Center(
            child: Text(
              '$total $toCurrency',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          'Last Updated on $lastUpdate',
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    );
  }
}
