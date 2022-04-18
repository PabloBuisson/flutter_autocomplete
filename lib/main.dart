import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/screens/autocomplete_ahead_screen.dart';
import 'package:flutter_autocomplete/screens/autocomplete_async_screen.dart';
import 'package:flutter_autocomplete/screens/autocomplete_sync_screen.dart';

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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Flutter Autocomplete Demo'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Synchronous', icon: Icon(Icons.date_range)),
                Tab(text: 'Asynchronous', icon: Icon(Icons.update)),
                Tab(text: 'Ahead', icon: Icon(Icons.wrap_text)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AutocompleteSyncScreen(),
              AutocompleteAsyncScreeen(),
              AutocompleteAheadScreen(),
            ],
          ),
        ),
//      home: const MyHomePage(title: 'Flutter Autocomplete Demo'),
      ),
    );
  }
}
