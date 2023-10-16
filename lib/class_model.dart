class DndClass {
  final String name;
  final String index;
  final int hitDie;
  final String? spells;
  final List<ProficiencyChoice>? proficiencyChoices;

  DndClass({
    required this.name,
    required this.index,
    required this.hitDie,
    required this.spells,
    required this.proficiencyChoices,
  });

  factory DndClass.fromJson(Map<String, dynamic> json) {
    List<ProficiencyChoice>? proficiencyChoices;
    if (json['proficiency_choices'] != null) {
      proficiencyChoices = List<ProficiencyChoice>.from(
          json['proficiency_choices'].map((choice) =>
              ProficiencyChoice.fromJson(choice as Map<String, dynamic>)));
    }

    return DndClass(
      name: json['name'],
      index: json['index'],
      hitDie: json['hit_die'],
      spells: json['spells'],
      proficiencyChoices: proficiencyChoices,
    );
  }
}

class ProficiencyChoice {
  final String desc;
  final int choose;
  final String type;
  final List<ProficiencyOption>? from;

  ProficiencyChoice({
    required this.desc,
    required this.choose,
    required this.type,
    required this.from,
  });

  factory ProficiencyChoice.fromJson(Map<String, dynamic> json) {
    List<ProficiencyOption>? from;
    if (json['from'] != null && json['from']['options'] != null) {
      from = List<ProficiencyOption>.from(json['from']['options'].map(
          (option) =>
              ProficiencyOption.fromJson(option as Map<String, dynamic>)));
    }

    return ProficiencyChoice(
      desc: json['desc'],
      choose: json['choose'],
      type: json['type'],
      from: from,
    );
  }
}

class ProficiencyOption {
  final String optionType;
  final ProficiencyItem item;

  ProficiencyOption({
    required this.optionType,
    required this.item,
  });

  factory ProficiencyOption.fromJson(Map<String, dynamic> json) {
    return ProficiencyOption(
      optionType: json['option_type'],
      item: ProficiencyItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class ProficiencyItem {
  final String index;
  final String name;
  final String url;

  ProficiencyItem({
    required this.index,
    required this.name,
    required this.url,
  });

  factory ProficiencyItem.fromJson(Map<String, dynamic> json) {
    return ProficiencyItem(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class DndApiItem {
  final String name;
  final String url;
  final String index;

  DndApiItem({required this.name, required this.url, required this.index});

  factory DndApiItem.fromJson(Map<String, dynamic> json) {
    return DndApiItem(
        name: json['name'], url: json['url'], index: json['index']);
  }
}
