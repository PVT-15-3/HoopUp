import 'package:flutter/material.dart';
import 'package:my_app/app_styles.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/handlers/event_handler.dart';
import 'package:my_app/widgets/list_event_widget.dart';
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
  late final HoopUpUserProvider _userProvider;
  final User _firebaseUser = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = context.read<FirebaseProvider>();
    _userProvider = context.read<HoopUpUserProvider>();
    if (_user?.id != _firebaseUser.uid ||
        (_userProvider.user == null && _user == null)) {
      _initializeData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeData() async {
    await _firebaseProvider
        .getUserFromFirebase(_firebaseUser.uid)
        .then((hoopUpUser) {
      _userProvider.setUser(hoopUpUser);
      _user = hoopUpUser;
    });
    await removeOldEvents(
        hoopUpUserProvider: _userProvider, firebaseProvider: _firebaseProvider);
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Toaster.showCustomToast(
          'Welcome, ${_user?.username}', Icons.sports_basketball, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateEventWizard(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 60),
                  backgroundColor: Styles.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text(
                  'CREATE GAME',
                  style: TextStyle(
                    fontSize: Styles.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: Styles.buttonFont,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: ListEventWidget(showJoinedEvents: false),
              ),
            ),
          ],
        ),
      );
    }
  }
}
