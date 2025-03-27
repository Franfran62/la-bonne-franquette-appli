
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';

class CommandeListProjection {
  int commandeId;
  int numero;
  DateTime dateSaisie;
  DateTime dateLivraison;
  int prixTTC;
  StatusCommande status;
  bool surPlace;
  bool paye;
  String paiementType;

  CommandeListProjection({
    required this.commandeId,
    required this.numero,
    required this.dateSaisie,
    required this.dateLivraison,
    required this.prixTTC,
    required this.status,
    required this.surPlace,
    required this.paye,
    required this.paiementType,
  });

  factory CommandeListProjection.fromJson(Map<String, dynamic> json) {
    return CommandeListProjection(
      commandeId: json['id'],
      numero: json['numero'],
      dateSaisie: DateTime.parse(json['dateSaisie']),
      dateLivraison: DateTime.parse(json['dateLivraison']),
      prixTTC: json['prixTTC'],
      status: StatusCommande.values.firstWhere((e) => e.name == json['status']),
      surPlace: json['surPlace'],
      paye: json['paye'],
      paiementType: json['paiementType'] ?? "",
    );
  }
 }