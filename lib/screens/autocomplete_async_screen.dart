import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/services/api_datamuse.dart';

class AutocompleteAsyncScreeen extends StatefulWidget {
  const AutocompleteAsyncScreeen({Key? key}) : super(key: key);

  @override
  _AutocompleteAsyncScreeenState createState() =>
      _AutocompleteAsyncScreeenState();
}

class _AutocompleteAsyncScreeenState extends State<AutocompleteAsyncScreeen> {
  // This will be displayed below the autocomplete field
  String? _selectedCity;

  // The list which holds the suggestions is no longer used
  // List<String> _suggestions = [];

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
              "What is your favorite item when you travel ? (asynchronous way)",
              textScaleFactor: 1.5,
              textAlign: TextAlign.start,
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Autocomplete<String>(
              // control the output
              optionsBuilder: (TextEditingValue value) async {
                // When the field is empty
                if (value.text.isEmpty || value.text.length < 3) {
                  setState(() {
                    // we reset the choice
                    _selectedCity = null;
                  });
                  return [];
                }
                // The logic to find out which ones should appear
                return await ApiDatamuse.getSuggestionsName(value.text);
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
                                leading: const Icon(Icons.star),
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
                  autofocus: true,
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
