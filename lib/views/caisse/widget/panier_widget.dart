import 'package:flutter/cupertino.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';

class PanierWidget extends StatefulWidget {
  final double height;

  PanierWidget({required this.height, super.key});

  @override
  _PanierWidgetState createState() => _PanierWidgetState();
}

class _PanierWidgetState extends State<PanierWidget> {
  final PanierViewModel viewModel = PanierViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(viewModel.getArticles().length.toString());
    return viewModel.getArticles().isEmpty
        ? Text("Panier vide")
        : ListView(
            children:
                viewModel.getArticles().map((e) => Text(e.nom)).toList(),
          );
  }
}
