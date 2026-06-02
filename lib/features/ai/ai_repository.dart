import 'dart:convert';

import 'package:http/http.dart' as http;

import 'chat_message.dart';

/// Repository for ARIELA AI API calls (Hugging Face Spaces).
///
/// Sends user questions to the deployed RAG service and returns
/// the most relevant answers from the curated dataset.
class AiRepository {
  AiRepository._();
  static final instance = AiRepository._();

  /// Base URL of the ARIELA AI API hosted on Hugging Face Spaces.
  /// The /ask endpoint accepts POST requests with a question + top_k.
  static const String _baseUrl =
      'https://shariel-ariela-ai.hf.space';

  /// Sends a user question to the AI and returns the top match.
  ///
  /// Returns the answer text directly, ready to display in the chat.
  Future<AiAnswer> ask(String question, {int topK = 3}) async {
    final url = Uri.parse('$_baseUrl/ask');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'top_k': topK,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI API error: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();

    if (results.isEmpty) {
      return const AiAnswer(
        answer: "I'm not sure how to help with that yet. "
            "Please consult a healthcare professional for personalized advice.",
        source: '',
        similarity: 0.0,
        relatedQuestions: [],
      );
    }

    final top = results.first;

    return AiAnswer(
      answer: top['answer'] as String? ?? '',
      source: top['source'] as String? ?? '',
      similarity: (top['similarity'] as num?)?.toDouble() ?? 0.0,
      relatedQuestions: results
          .skip(1)
          .map((r) => r['question'] as String? ?? '')
          .where((q) => q.isNotEmpty)
          .toList(),
    );
  }

  /// Health check — verify the API is reachable.
  Future<bool> isHealthy() async {
    try {
      final url = Uri.parse('$_baseUrl/');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

/// Response from the AI for a single user question.
class AiAnswer {
  const AiAnswer({
    required this.answer,
    required this.source,
    required this.similarity,
    required this.relatedQuestions,
  });

  final String answer;
  final String source;
  final double similarity;
  final List<String> relatedQuestions;

  /// True if the AI is confident (similarity > 0.5).
  bool get isConfident => similarity > 0.5;
}