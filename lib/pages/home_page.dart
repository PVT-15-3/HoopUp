import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/handlers/list_event_handler.dart';
import 'package:my_app/pages/create_event_wizard.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/toaster.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static HoopUpUser? _user;
  late final FirebaseProvider _firebaseProvider;
  
  @override
  void initState() {
    super.initState();
    final userProvider = context.read<HoopUpUserProvider>();
    _firebaseProvider = context.read<FirebaseProvider>();
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && userProvider.user == null && _user == null) {
      _firebaseProvider.getUserFromFirebase(firebaseUser.uid).then((hoopUpUser) {
        userProvider.setUser(hoopUpUser);
        _user = hoopUpUser;
        showCustomToast(
            'Welcome, ${_user?.username}', Icons.sports_basketball, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HoopUp'),
        actions: [
          IconButton(
            onPressed: () {
              print("!!!!!!!!");
              print(HoopUpUser.isSignedIn());
              print(_user);
              print("!!!!!!!!");
            },
            icon: const Icon(Icons.manage_accounts),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEventWizard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
              ),
              child: const Text(
                'Create Event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Expanded(
            child: Center(
              child: ListEventHandler(showJoinedEvents: false),
            ),
          ),
        ],
      ),
    );
  }
}
