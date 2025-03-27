import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/viewmodel/listedecommande_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/widget/choice_date_widget.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/widget/commande_list_widget.dart';

class ListeDeCommandePage extends StatefulWidget {
  const ListeDeCommandePage({Key? key}) : super(key: key);

  @override
  _ListeDeCommandePageState createState() => _ListeDeCommandePageState();
}

class _ListeDeCommandePageState extends State<ListeDeCommandePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListedeCommandeViewModel>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      scaffoldKey: _scaffoldKey,
      destination: "cuisine",
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ChoiceDateWidget(),
          ),
          CommandeListWidget(),
        ],
      ),
    );
  }
}
