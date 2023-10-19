class DndClass {
  final String name;
  final String index;
  final int hitDie;
  final String? spells;
  final List<ProficiencyChoice>? proficiencyChoices;
  final List<Proficiency>? proficiencies;
  final List<SavingThrows>? savingThrows;
  final List<StartingEquipment>? startingEquipment;
  final List<SubClass>? subclasses;
  final Spellcasting? spellcasting;

  DndClass({
    required this.name,
    required this.index,
    required this.hitDie,
    required this.spells,
    required this.proficiencyChoices,
    required this.proficiencies,
    required this.savingThrows,
    required this.startingEquipment,
    required this.subclasses,
    this.spellcasting,
  });

  factory DndClass.fromJson(Map<String, dynamic> json) {
    List<ProficiencyChoice>? proficiencyChoices;
    List<Proficiency>? proficiencies;
    List<SavingThrows>? savingThrows;
    List<StartingEquipment>? startingEquipment;
    List<SubClass>? subclasses;

    if (json['proficiency_choices'] != null) {
      proficiencyChoices = List<ProficiencyChoice>.from(
          json['proficiency_choices'].map((choice) =>
              ProficiencyChoice.fromJson(choice as Map<String, dynamic>)));
    }

    if (json['proficiencies'] != null) {
      proficiencies = List<Proficiency>.from(json['proficiencies'].map(
          (choice) => Proficiency.fromJson(choice as Map<String, dynamic>)));
    }

    if (json['saving_throws'] != null) {
      savingThrows = List<SavingThrows>.from(json['saving_throws'].map(
          (choice) => SavingThrows.fromJson(choice as Map<String, dynamic>)));
    }

    if (json['subclasses'] != null) {
      subclasses = List<SubClass>.from(json['subclasses']
          .map((choice) => SubClass.fromJson(choice as Map<String, dynamic>)));
    }

    if (json['starting_equipment'] != null) {
      startingEquipment = List<StartingEquipment>.from(
          json['starting_equipment'].map((equipment) =>
              StartingEquipment.fromJson(equipment as Map<String, dynamic>)));
    }

    return DndClass(
      name: json['name'],
      index: json['index'],
      hitDie: json['hit_die'],
      spells: json['spells'],
      proficiencyChoices: proficiencyChoices,
      proficiencies: proficiencies,
      savingThrows: savingThrows,
      startingEquipment: startingEquipment,
      subclasses: subclasses,
      spellcasting: json['spellcasting'] != null
          ? Spellcasting.fromJson(json['spellcasting'])
          : null,
    );
  }
}

class SubClass {
  final String index;
  final String name;
  final String url;

  SubClass({
    required this.index,
    required this.name,
    required this.url,
  });

  factory SubClass.fromJson(Map<String, dynamic> json) {
    return SubClass(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class Spellcasting {
  final int level;
  final SpellcastingAbility spellcastingAbility;
  final List<SpellcastingInfo> info;

  Spellcasting({
    required this.level,
    required this.spellcastingAbility,
    required this.info,
  });

  factory Spellcasting.fromJson(Map<String, dynamic> json) {
    return Spellcasting(
      level: json['level'],
      spellcastingAbility:
          SpellcastingAbility.fromJson(json['spellcasting_ability']),
      info: (json['info'] as List<dynamic>)
          .map((info) => SpellcastingInfo.fromJson(info))
          .toList(),
    );
  }
}

class SpellcastingAbility {
  final String index;
  final String name;
  final String url;

  SpellcastingAbility({
    required this.index,
    required this.name,
    required this.url,
  });

  factory SpellcastingAbility.fromJson(Map<String, dynamic> json) {
    return SpellcastingAbility(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class SpellcastingInfo {
  final String name;
  final List<String> desc;

  SpellcastingInfo({
    required this.name,
    required this.desc,
  });

  factory SpellcastingInfo.fromJson(Map<String, dynamic> json) {
    return SpellcastingInfo(
      name: json['name'],
      desc: List<String>.from(json['desc']),
    );
  }
}

class StartingEquipment {
  final Equipment equipment;
  final int quantity;

  StartingEquipment({
    required this.equipment,
    required this.quantity,
  });

  factory StartingEquipment.fromJson(Map<String, dynamic> json) {
    return StartingEquipment(
      equipment: Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      quantity: json['quantity'],
    );
  }
}

class Equipment {
  final String index;
  final String name;
  final String url;

  Equipment({
    required this.index,
    required this.name,
    required this.url,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class SavingThrows {
  final String name;
  final String url;

  SavingThrows({required this.name, required this.url});

  factory SavingThrows.fromJson(Map<String, dynamic> json) {
    return SavingThrows(name: json['name'], url: json['url']);
  }
}

class Proficiency {
  final String name;
  final String url;
  final String? type;

  Proficiency({required this.name, required this.url, this.type});

  factory Proficiency.fromJson(Map<String, dynamic> json) {
    return Proficiency(
        name: json['name'], url: json['url'], type: json['type']);
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
