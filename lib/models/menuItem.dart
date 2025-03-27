import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class MenuItem {
  
  final int id;
  final bool optional;
  final int? prixTTC;
  final List<Produit> produitSet;

  MenuItem({
    required this.id,
    required this.optional,
    this.prixTTC,
    required this.produitSet,
  });

  static Future<MenuItem> fromMenuJson(Map<String, dynamic> json) async {
    List<int> produitIdList = (json['produitSet'] as List<dynamic>).map((produit) => produit['id'] as int).toList();
    List<Produit> produitSet = await DatabaseService.findProduitByIds(produitIdList);
    return MenuItem(
      id: json['id'] as int,
      optional: json['optional'] as bool,
      prixTTC: json['prixTTC'] as int?,
      produitSet: produitSet,
    );
  }

  static MenuItem fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      optional: map['optional'] == 1,
      prixTTC: map['prixTTC'],
      produitSet: [],
    );
  }

   @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MenuItem otherMenuItem = other as MenuItem;
    return id == otherMenuItem.id &&
            otherMenuItem.optional == optional &&
            otherMenuItem.prixTTC == prixTTC &&
            ListEquality().equals(produitSet, otherMenuItem.produitSet);
  }

  @override
  int get hashCode => Object.hash(
        id, prixTTC, optional,
        ListEquality().hash(produitSet),
      );
}

