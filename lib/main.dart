import 'package:flutter/material.dart';
import 'package:my_app/pages/create_event.dart';
import 'package:my_app/pages/create_event_wizard.dart';
import 'package:my_app/pages/event_viewer_page.dart';
import 'package:my_app/pages/list_events.dart';
import 'package:my_app/pages/sign_up_page.dart';
import 'package:my_app/providers/create_event_wizard_provider.dart';
import 'package:provider/provider.dart';
import 'pages/map.dart';
import 'pages/main_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/profile_page.dart';
import 'services/firebase_options.dart';
import 'providers/hoopup_user_provider.dart';
import 'pages/log_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HoopUpUserProvider()),
        ChangeNotifierProvider(create: (_) => CreateEventWizardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MainMenu(),
        routes: {
          '/map': (context) => const Map(),
          '/create_event.dart': (context) => CreateEventPage(),
          '/create_event_wizard.dart': (context) => CreateEventWizard(),
          '/sign_up_page.dart': (context) => SignUpPage(),
          '/log_in_page.dart': (context) => LogInPage(),
          '/profile_page.dart': (context) => const ProfilePage(),
          '/list_events.dart': (context) => ListEventsPage(),
        },
      ),
    );
  }
}
