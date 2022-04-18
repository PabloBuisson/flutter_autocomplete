class SuggestionDatamuse {
  final int score;
  final String word;

  SuggestionDatamuse({
    required this.score,
    required this.word,
  });

  factory SuggestionDatamuse.fromJson(Map<String, dynamic> json) {
    return SuggestionDatamuse(
      word: json['word'],
      score: json['score'],
    );
  }
}
