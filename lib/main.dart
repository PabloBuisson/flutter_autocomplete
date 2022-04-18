import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Autocomplete Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Flutter Autocomplete Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This will be displayed below the autocomplete field
  String? _selectedCity;

  // This list holds all the suggestions
  final List<String> _suggestions = [
    'Paris',
    'New-York',
    'Madrid',
    'London',
    'Beijing',
    'Rio',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Padding(
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
      ),
    );
  }
}
