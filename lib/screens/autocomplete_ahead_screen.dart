import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/services/api_datamuse.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteAheadScreen extends StatefulWidget {
  const AutocompleteAheadScreen({Key? key}) : super(key: key);

  @override
  _AutocompleteAheadScreenState createState() =>
      _AutocompleteAheadScreenState();
}

class _AutocompleteAheadScreenState extends State<AutocompleteAheadScreen> {
  final TextEditingController _typeAheadController = TextEditingController();
  String? _selectedSuggestion;

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
              "What is your favorite item when you travel ? (TypeAhead way)",
              textScaleFactor: 1.5,
              textAlign: TextAlign.start,
            ),
          ),
          TypeAheadField<String>(
            // 💡 add a delay to send a request 500ms after last keystroke
            // to prevent excessive amount of requests
            // the duration defaults to 300 milliseconds
            debounceDuration: const Duration(milliseconds: 500),
            // UI of the textfield
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              // to update the text on the textfield with the selected suggestion
              controller: _typeAheadController,
              style:
                  DefaultTextStyle.of(context).style.copyWith(fontSize: 18.0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _selectedSuggestion != null
                      ? const Icon(Icons.check_box_rounded)
                      : null),
            ),
            suggestionsCallback: (pattern) async {
              return await ApiDatamuse.getSuggestions(pattern);
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text("No item found !"),
            ),
            itemBuilder: (context, String suggestion) {
              return ListTile(
                leading: const Icon(Icons.star),
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) {
              setState(() {
                _selectedSuggestion = suggestion;
              });
              _typeAheadController.text = suggestion;
            },
          ),
        ],
      ),
    );
  }
}
