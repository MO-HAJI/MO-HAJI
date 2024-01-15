class ResponseModel {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;

  ResponseModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
  });

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      id: map['id'] as String,
      object: map['object'] as String,
      created: map['created'] as int,
      model: map['model'] as String,
      choices: (map['choices'] as List)
          .map((choice) => Choice.fromMap(choice))
          .toList(),
    );
  }
}

class Choice {
  final String text;

  Choice({required this.text});

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      text: map['text'] as String,
    );
  }
}
