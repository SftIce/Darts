class Player {
  String name;
  int score;
  Map<String, int> marks; // Used for Cricket

  Player({required this.name, this.score = 0, Map<String, int>? marks})
      : marks = marks ?? {
          '20': 0, '19': 0, '18': 0, '17': 0, '16': 0,
          '15': 0, '14': 0, '13': 0, '12': 0, '11': 0,
          '10': 0, 'Bull': 0
        };
}
