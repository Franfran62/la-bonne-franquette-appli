import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/category.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/row_product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/row_subcategory.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/element_button.dart';

class RowCategory extends HookWidget {
  final List<Category>? categories;
  final double size;
  final TextScaler fontSize;
  final VoidCallback onPressed;

  RowCategory(
      {super.key,
      required this.categories,
      required this.size,
      required this.fontSize,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Map<String, List> defaultList = {
      "products": <Product>[],
      "sub-categories": <Category>[],
    };
    final listAffiche = useState<Map<String, List>>(defaultList);

    update(Map<String, List> newList) {
      listAffiche.value = newList;
    }

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
                            onPressed: () {
                              update({
                                "products": element.products,
                                "sub-categories": element.subCategories
                              });
                            },
                            selected: (element.products ==
                                    listAffiche.value["products"] ||
                                element.subCategories ==
                                    listAffiche.value["sub-categories"]),
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        SizedBox(
          height: size * 2,
          child: listAffiche.value.isNotEmpty
              ? listAffiche.value["sub-categories"]!.isNotEmpty
                  ? Container(
                      alignment: Alignment.topLeft,
                      child: RowSubCategory(
                        categories: listAffiche.value['sub-categories']
                            as List<Category>,
                        size: size,
                        fontSize: fontSize,
                        onPressed: onPressed,
                      ),
                    )
                  : listAffiche.value["products"]!.isNotEmpty
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size,
                                child: RowProduct(
                                  products: listAffiche.value["products"]
                                      as List<Product>,
                                  fontSize: fontSize,
                                  onPressed: onPressed,
                                ),
                              ),
                              SizedBox(
                                height: size,
                              )
                            ],
                          ),
                        )
                      : SizedBox()
              : SizedBox(),
        )
      ],
    );
  }
}
