import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFF2F3AE), // Couleur primary
      secondaryHeaderColor: const Color(0xFFEDD382), // Couleur secondary
      hoverColor: const Color(0xFFFC9E4F), // Couleur d'accentuation
      disabledColor: const Color(0xFFFF521B), // Couleur d'erreur
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