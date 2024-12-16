import 'package:flutter/material.dart';

class CurrencySwapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrencySwapButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.swap_horiz,
        // fill: 5,
        opticalSize: 20,
      ),
    );
  }
}
