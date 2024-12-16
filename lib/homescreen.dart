import 'package:currconv2/amountinput.dart';
import 'package:currconv2/buttonswap.dart';
// import 'package:currconv2/conversion.dart';
import 'package:currconv2/dropdownbutton.dart';
import 'package:currconv2/exchangerate.dart';
import 'package:currconv2/screens.dart';
import 'package:currconv2/settings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExchangeRateService exchangeRateService = ExchangeRateService();

  String fromCurrency = 'USD';
  String toCurrency = 'NGN';
  double rate = 0.0;
  double total = 0.0;
  String lastUpdate = '';
  TextEditingController amountController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> currencies = [];

  // State variable to track which screen is active
  var activeScreen = 'Home';

  @override
  void initState() {
    super.initState();
    _getCurrencies();
    _getRateAndTime();
  }

  Future<void> _getCurrencies() async {
    try {
      final data = await exchangeRateService.fetchCurrencies();
      setState(() {
        currencies = data.keys.toList();
      });
    } catch (e) {
      _showSnackBar('Wahala');
    }
  }

  Future<void> _getRateAndTime() async {
    try {
      final data = await exchangeRateService.fetchRateAndTime(fromCurrency);
      setState(() {
        rate = data['conversion_rates'][toCurrency];
        lastUpdate = data['time_last_update_utc'];
        if (amountController.text.isNotEmpty) {
          total = double.parse(amountController.text) * rate;
        }
      });
    } catch (e) {
      _showSnackBar('Wahala');
    }
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRateAndTime();
    });
  }

  // Method to change the active screen
  _changeView(String identifier) {
    setState(() {
      activeScreen = identifier;
      Navigator.pop(context);
    });
  }

  _parseAmount() {
    setState(() {
      total = int.parse(amountController.text) * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Conditional rendering based on the activeScreen state
    return Scaffold(
      drawer: SettingsScreen(
          selectScreen: _changeView), // Pass changeView method to drawer
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to any color you want
        ),
        backgroundColor: const Color.fromARGB(255, 0, 10, 24),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'CURRENCY CONVERTER',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: activeScreen == 'Home'
          ? homeScreen() // Render home screen content
          : const MyWidget(), // Render settings screen content (or any other screen)
    );
  }

  // Home screen content
  Widget homeScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset('lib/assets/Animation - 1723642931616.json'),
            Padding(
              padding: const EdgeInsets.all(05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CurrencyDropdown(
                    value: fromCurrency,
                    currencies: currencies,
                    onChanged: (newValue) {
                      setState(() {
                        fromCurrency = newValue!;
                        _getRateAndTime();
                      });
                    },
                    searchController: searchController,
                    width: 100,
                  ),
                  CurrencySwapButton(onPressed: _swapCurrencies),
                  CurrencyDropdown(
                    value: toCurrency,
                    currencies: currencies,
                    onChanged: (newValue) {
                      setState(() {
                        toCurrency = newValue!;
                        _getRateAndTime();
                      });
                    },
                    searchController: searchController,
                    width: 100,
                  ),
                ],
              ),
            ),
            AmountInputField(
              controller: amountController,
              onChanged: _parseAmount,
            ),
            const SizedBox(height: 10),
            Text(
              '$fromCurrency to $toCurrency = $rate',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            amountController.text.isNotEmpty
                ? Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      '${amountController.text.isEmpty ? null : amountController.text} $fromCurrency to $toCurrency = ${total.toStringAsFixed(3)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Last Updated on $lastUpdate',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
