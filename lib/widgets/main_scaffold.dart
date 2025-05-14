import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/widgets/side_menu.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final String destination;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? title;

  MainScaffold(
      {required this.body,
      required this.destination,
      required this.scaffoldKey,
      this.title,
      super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: SideMenu(
          destination: widget.destination,
          context: context,
          scaffoldKey: widget.scaffoldKey),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer()),
        title: Text(widget.title ?? ""),
        actions: [
          InkWell(
            onTap: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              }
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: widget.body,
    );
  }
}
