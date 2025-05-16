import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/order_list_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/widget/choice_date_widget.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/widget/order_list_widget.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({Key? key}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderListViewModel>(context, listen: false).init();
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
          OrderListWidget(),
        ],
      ),
    );
  }
}
