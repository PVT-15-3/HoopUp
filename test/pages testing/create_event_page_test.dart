// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:my_app/classes/hoopup_user.dart';
// import 'package:my_app/pages/create_event_wizard.dart';
// import 'package:my_app/pages/profile_page.dart';
// import 'package:my_app/providers/create_event_wizard_provider.dart';
// import 'package:my_app/providers/firebase_provider.dart';
// import 'package:my_app/providers/hoopup_user_provider.dart';
// import 'package:provider/provider.dart';

// class MockDatabase extends Mock implements FirebaseProvider {}

// void main() {
//   late HoopUpUser user;
//   late HoopUpUserProvider userProvider;
//   late MockDatabase firebaseProvider;
//   late CreateEventWizardProvider wizardProvider;

//   setUp(() {
//     firebaseProvider = MockDatabase();
//     userProvider = HoopUpUserProvider();
//     wizardProvider = CreateEventWizardProvider();

//     user = HoopUpUser(
//         username: "Geoff",
//         skillLevel: 1,
//         id: "id1",
//         photoUrl: "photo",
//         gender: "Male",
//         firebaseProvider: firebaseProvider);
//     userProvider.setUser(user);
//   });

//   Widget createWidgetUnderTest() {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => userProvider),
//         ChangeNotifierProvider(create: (_) => wizardProvider),
//         ChangeNotifierProvider(create: (_) => firebaseProvider),
//       ],
//       child: MaterialApp(
//         home: CreateEventWizard(),
//       ),
//     );
//   }
// }
