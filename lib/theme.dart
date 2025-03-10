import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData getTheme() {
    return ThemeData(

      highlightColor: Colors.green, 
      colorScheme: const ColorScheme.light(
        primary:   Color(0xFFEDD382),
        secondary: Color(0xFFF2F3AE),
        tertiary:  Color(0xFFFC9E4F),
        error: Color(0xFFFF521B),
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainer: Colors.white,
        inversePrimary: Color(0xFF020122),
      ),
      
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.notoSans( 
          fontWeight: FontWeight.w500, 
          color: Colors.black, 
          fontSize: 20
        ),
        bodyMedium: GoogleFonts.notoSans( 
          fontWeight: FontWeight.normal, 
          color: Colors.black, 
          fontSize: 16
        ),
        bodySmall: GoogleFonts.notoSans( 
          fontWeight: FontWeight.normal, 
          color: Colors.black, 
          fontSize: 12
        ),
        headlineLarge: GoogleFonts.notoSans( 
          fontWeight: FontWeight.bold, 
          color: Colors.black, 
          fontSize: 28,
        ), 
        headlineMedium: GoogleFonts.notoSans( 
          fontWeight: FontWeight.bold, 
          color: Colors.black, 
          fontSize: 24,
        ), 
        headlineSmall: GoogleFonts.notoSans( 
          fontWeight: FontWeight.bold, 
          color: Colors.black, 
          fontSize: 22,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme( 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 30),
      ),

       elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((states) =>  const Color(0xFFEDD382)), 
          foregroundColor: WidgetStateColor.resolveWith((states) => Colors.black), 
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide.none,
            ),
          ),
          textStyle: WidgetStateProperty.all(
            GoogleFonts.notoSans(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          padding:  WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateColor.resolveWith((states) {
            return const Color(0xFFEDD382);
        }),
        trackColor: WidgetStateColor.resolveWith((states) { 
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFFC9E4F);
          }
          return Colors.white;
        }),
        trackOutlineColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return  const Color(0xFFFC9E4F);
          } else {
            return Colors.grey.shade700;
          }
        }),
      ),
    );
  }

    static ElevatedButtonThemeData getSecondaryElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => const Color(0xFFF2F3AE)), 
        foregroundColor: WidgetStateColor.resolveWith((states) => Colors.black), 
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide.none,
          ),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        ),
      ),
    );
  }

  static InputDecoration getInputDecoration({required String label, required String placeholder, required BuildContext context, suffixIcon}) {
    ThemeData theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodyMedium,
      hintText: placeholder,
      hintStyle: theme.textTheme.bodyMedium,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: suffixIcon,
    );
  }
}