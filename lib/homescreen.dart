import 'package:currconv2/exchangerate.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    searchController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _getCurrencies(),
      _getRateAndTime(),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> _getCurrencies() async {
    try {
      final data = await exchangeRateService.fetchCurrencies();
      setState(() => currencies = data.keys.toList()..sort());
    } catch (e) {
      _showError('Failed to fetch currencies');
    }
  }

  Future<void> _getRateAndTime() async {
    try {
      final data = await exchangeRateService.fetchRateAndTime(fromCurrency);
      setState(() {
        rate = data['conversion_rates'][toCurrency];
        lastUpdate = data['time_last_update_utc'];
        _calculateTotal();
      });
    } catch (e) {
      _showError('Failed to fetch exchange rates');
    }
  }

  void _calculateTotal() {
    if (amountController.text.isNotEmpty) {
      setState(() {
        total = double.parse(amountController.text) * rate;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _swapCurrencies() {
    setState(() {
      final temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRateAndTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text('Currency Converter'),
            expandedHeight: 250, // Increased height
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 80), // Added padding to prevent overlap with title
                    child: Lottie.asset(
                      'lib/assets/Animation - 1723642931616.json',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 32, 16, 32), // Increased padding
                    child: Column(
                      children: [
                        _buildConverterCard(),
                        const SizedBox(height: 32), // Increased spacing
                        _buildResultCard(),
                        const SizedBox(height: 32), // Added bottom spacing
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConverterCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calculateTotal(),
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.attach_money),
                contentPadding: const EdgeInsets.all(16), // Added padding
              ),
            ),
            const SizedBox(height: 24), // Increased spacing
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Better distribution
              children: [
                Expanded(
                  flex: 2, // Adjusted flex
                  child: _buildCurrencyDropdown(
                    value: fromCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          fromCurrency = value;
                          _getRateAndTime();
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Increased padding
                  child: IconButton(
                    onPressed: _swapCurrencies,
                    icon: const Icon(Icons.swap_horiz,
                        size: 28), // Increased icon size
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      padding: const EdgeInsets.all(12), // Added padding
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Adjusted flex
                  child: _buildCurrencyDropdown(
                    value: toCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          toCurrency = value;
                          _getRateAndTime();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton2<String>(
      value: value,
      items: currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 56, // Increased height
        width: 150, // Increased width
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Added vertical padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.grey.shade400),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        padding: const EdgeInsets.symmetric(vertical: 8), // Added padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 60, // Increased height
        padding: EdgeInsets.symmetric(horizontal: 16), // Added padding
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidgetHeight: 56, // Increased height
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(12), // Increased padding
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'Search for currency...',
              hintStyle: const TextStyle(fontSize: 14), // Increased font size
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return item.value
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase());
        },
      ),
    );
  }

  Widget _buildResultCard() {
    if (amountController.text.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${amountController.text} $fromCurrency equals',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), // Increased spacing
            Text(
              '$total $toCurrency',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), // Increased spacing
            Text(
              '1 $fromCurrency = ${rate.toStringAsFixed(4)} $toCurrency',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24), // Increased spacing
            Text(
              'Last updated: $lastUpdate',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
