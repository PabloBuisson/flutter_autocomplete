import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter_autocomplete/models/suggestion_datamuse.dart';
import 'package:http/http.dart' as http;

class ApiDatamuse {
  static Future<List<String>> getSuggestionsName(String query) async {
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }

    var url = Uri.https('api.datamuse.com', '/sug', {'s': query});
    var response = await http.get(url);
    List<SuggestionDatamuse> suggestions = [];

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      suggestions = List<SuggestionDatamuse>.from(
          json.map((model) => SuggestionDatamuse.fromJson(model)));

      print('Number of suggestion: ${suggestions.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(
        suggestions.map((suggestion) => suggestion.word).toList());
  }

  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }

    var url = Uri.https('api.datamuse.com', '/sug', {'s': query});
    var response = await http.get(url);
    List<SuggestionDatamuse> suggestions = [];

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      suggestions = List<SuggestionDatamuse>.from(
          json.map((model) => SuggestionDatamuse.fromJson(model)));
      print('Number of suggestion: ${suggestions.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(suggestions
        .map((e) => {'name': e.word, 'score': e.score.toString()})
        .toList());
  }
}
