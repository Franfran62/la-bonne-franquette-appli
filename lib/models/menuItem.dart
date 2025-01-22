import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class MenuItem {
  
  final int id;
  final bool optional;
  final int? extraPriceHT;
  final List<Produit> produitSet;

  MenuItem({
    required this.id,
    required this.optional,
    this.extraPriceHT,
    required this.produitSet,
  });

  static Future<MenuItem> fromMenuJson(Map<String, dynamic> json) async {
    List<int> produitIdList = (json['produitSet'] as List<dynamic>).map((produit) => produit['id'] as int).toList();
    List<Produit> produitSet = await DatabaseService.findProduitByIds(produitIdList);
    return MenuItem(
      id: json['id'] as int,
      optional: json['optional'] as bool,
      extraPriceHT: json['extraPriceHT'] as int?,
      produitSet: produitSet,
    );
  }

  static MenuItem fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      optional: map['optional'] == 1,
      extraPriceHT: map['extraPriceHT'],
      produitSet: [],
    );
  }
}

