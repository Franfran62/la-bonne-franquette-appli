import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/element_button.dart';
import '../order_entry_viewmodel.dart';

class RowProduct extends StatelessWidget {
  RowProduct({
    super.key,
    required this.products,
    required this.fontSize,
    required this.onPressed,
  });

  final List<Product>? products;
  final TextScaler fontSize;
  final OrderEntryViewModel viewModel = OrderEntryViewModel();
  final VoidCallback onPressed;

  Future<void> handlePress(Product produit) async {
    await viewModel.addProductToCart(produit);
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: products != null && products!.isNotEmpty
            ? [
                ...products!.map((element) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ElementButton(
                          element: element.name,
                          fontSize: fontSize,
                          onPressed: () => handlePress(element)),
                    )),
              ]
            : [],
      ),
    );
  }
}
