import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String value;
  final List<String> currencies;
  final Function(String?) onChanged;
  final TextEditingController searchController;
  final double width;

  const CurrencyDropdown({
    required this.value,
    required this.currencies,
    required this.onChanged,
    required this.searchController,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: value,
          isExpanded: true,
          style: const TextStyle(color: Colors.black),
          items: currencies.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownStyleData: const DropdownStyleData(
            
              direction: DropdownDirection.textDirection,
              useSafeArea: true,
              maxHeight: 400,
              padding: EdgeInsets.symmetric(vertical: 6),
              offset: Offset(0, 50)),
          dropdownSearchData: DropdownSearchData(
            
            searchController: searchController,
            searchInnerWidgetHeight: 100,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
        ),
      ),
    );
  }
}
