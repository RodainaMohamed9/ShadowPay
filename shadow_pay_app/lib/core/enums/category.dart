enum Category {
  entertainment,
  foodDining,
  gasTransport,
  groceryNet,
  groceryPos,
  healthFitness,
  home,
  kidsPets,
  miscNet,
  miscPos,
  personalCare,
  shoppingNet,
  shoppingPos,
  travel,
}

int categoryToId(Category c) => c.index + 1;

Category idToCategory(int id) => Category.values[id - 1];

extension CategoryDisplay on Category {
  String get displayName {
    switch (this) {
      case Category.entertainment:
        return "Entertainment";
      case Category.foodDining:
        return "Food & Dining";
      case Category.gasTransport:
        return "Gas & Transport";
      case Category.groceryNet:
        return "Grocery (Online)";
      case Category.groceryPos:
        return "Grocery (Store)";
      case Category.healthFitness:
        return "Health & Fitness";
      case Category.home:
        return "Home";
      case Category.kidsPets:
        return "Kids & Pets";
      case Category.miscNet:
        return "Misc (Online)";
      case Category.miscPos:
        return "Misc (Store)";
      case Category.personalCare:
        return "Personal Care";
      case Category.shoppingNet:
        return "Shopping (Online)";
      case Category.shoppingPos:
        return "Shopping (Store)";
      case Category.travel:
        return "Travel";
    }
  }
}