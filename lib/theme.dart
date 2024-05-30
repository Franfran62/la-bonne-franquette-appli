import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Colors.blue, // Couleur primary
      secondaryHeaderColor: Colors.green, // Couleur secondary
      hoverColor: Colors.white, // Couleur d'accentuation
      disabledColor: Colors.red, // Couleur d'erreur
      highlightColor: Colors.green, // Couleur de succès
      
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.notoSans( //Police de texte
          fontWeight: FontWeight.normal, 
          color: Colors.black, 
        ),
        headlineMedium: GoogleFonts.lora( //Police de titre
          fontWeight: FontWeight.bold, 
          color: Colors.black, 
        ), 
      ),
    );
  }
}