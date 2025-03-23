import 'package:flutter/foundation.dart';

class ListedeCommandeViewModel extends ChangeNotifier {
  ListedeCommandeViewModel._internal();

  static final ListedeCommandeViewModel _singleton =
      ListedeCommandeViewModel._internal();

  factory ListedeCommandeViewModel() {
    return _singleton;
  }
}
