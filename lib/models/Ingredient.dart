class Ingredient {
  final int id;
  final String nom;
  final bool aCuire;
  final List<Ingredient> extras; //Liste des extras contenant cet ingrédient

  const Ingredient({
    required this.id,
    required this.nom,
    required this.aCuire,
    required this.extras,
  });
  
  factory Ingredient.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "aCuire": bool aCuire,
        "extras": List<Ingredient> extras,
      } => 
        Ingredient(id: id, nom: nom, aCuire: aCuire, extras: extras),
        _ => throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  int getId() {
    return this.id;
  }

  String getNom() {
    return this.nom;
  }

  bool getACuire() {
    return this.aCuire;
  }

  List<Ingredient> getExtras() {
    return this.extras;
  }

}