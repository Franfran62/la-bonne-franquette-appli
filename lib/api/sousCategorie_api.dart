import 'package:http/http.dart' as http;

import '../models/SousCategorie.dart';

Future<SousCategorie> fetchAlbum() async {
    final response = await http.get(Uri.parse(''));

    if(response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Error : Failed to load this Album !');
    }
  }