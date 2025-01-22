enum Tables {
  ingredient(name: "ingredient"),
  extra(name: "extra"),
  categorie(name: "categorie"),
  produit(name: "produit"),
  menu(name: "menu"),
  menuItem(name: "menu_item"),
  menuItemContientProduit(name: "menu_item_contient_produit"),
  produitContientIngredient(name: "produit_contient_ingredient"),
  produitAppartientCategorie(name: "produit_appartient_categorie"),
  menuContientProduit(name: "menu_contient_produit");

  const Tables({
    required this.name,
  });

  final String name;
}