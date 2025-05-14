enum Tables {
  ingredient(name: "ingredients"),
  addon(name: "addons"),
  category(name: "categories"),
  product(name: "products"),
  menu(name: "menus"),
  menuItem(name: "menu_items"),
  menuItemContainsProduct(name: "menu_item_contains_product"),
  productContainsIngredient(name: "product_contains_ingredient"),
  productContainsAddon(name: "product_contains_addon"),
  productInCategory(name: "product_in_category"),
  menuContainsProduct(name: "menu_contains_product"),
  paymentType(name: "payment_type");

  const Tables({
    required this.name,
  });

  final String name;
}