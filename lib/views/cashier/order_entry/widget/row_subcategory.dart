import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import '../../../../models/category.dart';
import 'row_product.dart';
import 'element_button.dart';

class RowSubCategory extends HookWidget {
  final List<Category>? categories;
  final double size;
  final TextScaler fontSize;
  final VoidCallback onPressed;

  const RowSubCategory({
    super.key,
    required this.categories,
    required this.size,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    List<Product> defaultList = [];
    final listAffiche = useState<List<Product>>(defaultList);

    updateProduitsAffiches(List<Product> newList) {
      listAffiche.value = newList;
    }

    // Reset des produits a afficher quand on change de catégorie
    useEffect(() {
      updateProduitsAffiches(defaultList);
      return null;
    }, [categories]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          height: size,
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: categories != null && categories!.isNotEmpty
                ? [
                    ...categories!.map((element) => Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ElementButton(
                            element: element.name,
                            fontSize: fontSize,
                            onPressed: () =>
                                updateProduitsAffiches(element.products),
                            selected: element.products == listAffiche.value,
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          height: size,
          child: listAffiche.value.isNotEmpty
              ? RowProduct(
                  products: listAffiche.value,
                  fontSize: fontSize,
                  onPressed: onPressed,
                )
              : SizedBox(),
        )
      ],
    );
  }
}
