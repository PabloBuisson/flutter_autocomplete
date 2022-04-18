import 'package:flutter/material.dart';

class AutocompleteSyncScreen extends StatefulWidget {
  const AutocompleteSyncScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteSyncScreen> createState() => _AutocompleteSyncScreenState();
}

class _AutocompleteSyncScreenState extends State<AutocompleteSyncScreen> {
  // This will be displayed below the autocomplete field
  String? _selectedCity;

  // This list holds all the suggestions
  final List<String> _suggestions = [
    'Paris',
    'New-York',
    'Madrid',
    'London',
    'Oslo',
    'Sydney',
    'Rio',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "What is your favorite city ? (synchronous way)",
              textScaleFactor: 1.5,
              textAlign: TextAlign.start,
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Autocomplete<String>(
              // control the output
              optionsBuilder: (TextEditingValue value) {
                // When the field is empty
                if (value.text.isEmpty) {
                  setState(() {
                    // we reset the choice
                    _selectedCity = null;
                  });
                  return [];
                }
                // The logic to find out which ones should appear
                return _suggestions.where((suggestion) => suggestion
                    .toLowerCase()
                    .contains(value.text.toLowerCase()));
              },
              // display the UI of suggestions
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Theme.of(context).primaryColorLight,
                    elevation: 4.0,
                    // size works, when placed here below the Material widget
                    child: SizedBox(
                      // resolve an unfixed bug => https://github.com/flutter/flutter/issues/78746
                      width: constraints.biggest.width,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: false,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return InkWell(
                              onTap: () => {onSelected(option)},
                              child: ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Text(
                                  option,
                                  style: TextStyle(
                                      fontWeight: index == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                );
              },
              // control the UI
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _selectedCity != null
                          ? const Icon(Icons.check_box_rounded)
                          : null),
                  style: const TextStyle(fontSize: 18.0),
                );
              },
              // control the selection
              onSelected: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
