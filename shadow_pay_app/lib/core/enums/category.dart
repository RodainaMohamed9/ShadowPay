import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

enum RiskLevel {
  lowRisk(Color(0xFF00D8A2), "Low Risk"),
  mediumRisk(Color(0xFFFF9800), "Medium Risk"),
  highRisk(Color(0xFFF44336), "High Risk"),
  unknown(Color(0xFFAAAAAA), "Unknown");

  final Color color;
  final String backendValue;
  
  const RiskLevel(this.color, this.backendValue);

  static RiskLevel fromString(String? value) {
    if (value == null) return RiskLevel.unknown;
    if (value.contains("Low")) return RiskLevel.lowRisk;
    if (value.contains("Medium")) return RiskLevel.mediumRisk;
    if (value.contains("High")) return RiskLevel.highRisk;
    return RiskLevel.unknown;
  }
}

enum Category {
  entertainment(Icons.movie),
  foodDining(Icons.restaurant),
  gasTransport(Icons.local_gas_station),
  groceryNet(Icons.shopping_cart),
  groceryPos(Icons.shopping_cart),
  healthFitness(Icons.fitness_center),
  home(Icons.home),
  kidsPets(Icons.pets),
  miscNet(Icons.category),
  miscPos(Icons.category),
  personalCare(Icons.spa),
  shoppingNet(Icons.shopping_bag),
  shoppingPos(Icons.shopping_bag),
  travel(Icons.flight);

  final IconData icon;

  const Category(this.icon);
}

int categoryToId(Category c) => c.index;

Category idToCategory(int id) {
  if (id >= 0 && id < Category.values.length) {
    return Category.values[id];
  }
  return Category.miscNet;
}

extension CategoryDisplay on Category {
  String displayName(AppLocalizations loc) {
    switch (this) {
      case Category.entertainment:
        return loc.entertainment;
      case Category.foodDining:
        return loc.foodDining;
      case Category.gasTransport:
        return loc.gasTransport;
      case Category.groceryNet:
        return loc.groceryNet;
      case Category.groceryPos:
        return loc.groceryPos;
      case Category.healthFitness:
        return loc.healthFitness;
      case Category.home:
        return loc.home;
      case Category.kidsPets:
        return loc.kidsPets;
      case Category.miscNet:
        return loc.miscNet;
      case Category.miscPos:
        return loc.miscPos;
      case Category.personalCare:
        return loc.personalCare;
      case Category.shoppingNet:
        return loc.shoppingNet;
      case Category.shoppingPos:
        return loc.shoppingPos;
      case Category.travel:
        return loc.travel;
    }
  }
}