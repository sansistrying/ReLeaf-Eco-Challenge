//lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/supabase_config.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone
  tz.initializeTimeZones();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReLeaf',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          primary: Colors.green.shade300, // Lighter green for primary elements
          primaryContainer: Colors.green.shade700, // Darker green for containers
          secondary: Colors.black, // Black for secondary elements
          secondaryContainer: Colors.grey.shade800, // Dark grey for contrast
          surface: Colors.grey.shade900, // Dark surface for dark theme
          background: Colors.black, // Black background
          error: Colors.red.shade400, // Error color
          onPrimary: Colors.black, // Text color on primary
          onSecondary: Colors.white, // Text color on secondary
          onSurface: Colors.white, // Text color on surface
          onBackground: Colors.white, // Text color on background
          onError: Colors.black, // Text color on error
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
      ),
      themeMode: ThemeMode.dark, // Set the app to use dark mode by default
      home: const MainScreen(),
    );
  }
}