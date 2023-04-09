import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/map.dart';
import 'pages/main_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'services/hoopup_user_provider.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const MainMenu(),
        routes: {
          '/map': (context) => const Map(),
        },
      ),
    );
  }
}
