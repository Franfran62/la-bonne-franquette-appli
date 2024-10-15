import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/widgets/sideMenu/side_menu_widget.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final String destination;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  MainScaffold(
      {required this.body,
      required this.destination,
      required this.title,
      required this.scaffoldKey,
      super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState  extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        drawer: SideMenuWidget(destination: widget.destination, context: context, scaffoldKey: widget.scaffoldKey),
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => widget.scaffoldKey.currentState?.openDrawer()
          ),
          title: Text(widget.title),
        ),
        body: widget.body
    );
  }
}
