import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:realestate/view/login_screen.dart';
import 'package:realestate/view/my_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'consts.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'view/main_screen.dart';

void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String loginEmailID = '', loginPassword = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginFunction();
  }
  loginFunction() async{
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn')!;
    loginEmailID = prefs.getString('email') ?? '';
    loginPassword = prefs.getString('password') ?? '';

    final user = UserLogin(email: loginEmailID, password: loginPassword);
    final success = await UserController.loginUser(user);
    setState(() {
      isLoggedIn = true;
    });
    prefs.setBool('isLoggedIn', isLoggedIn);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealEstate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 227, 231, 239)),
        useMaterial3: false,
      ),
      initialRoute: '/main_screen',
      routes: {
        '/main_screen':(context) => const MainScreen(),
        '/login_screen':(context) => const LoginScreen(),
        '/profile_page':(context) => const MyProfile(),
      },
    );
  }
}

// Firebase configuration file lib/firebase_options.dart generated successfully with the following Firebase apps:
//
// Platform  Firebase App Id
// android   1:847318552692:android:a1e40d72039ba03355c121
// ios       1:847318552692:ios:f80b17094ea0039a55c121


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'RealEstate',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 227, 231, 239)),
//         useMaterial3: false,
//       ),
//       initialRoute: '/main_screen',
//       routes: {
//         '/main_screen':(context) => const MainScreen(),
//         '/login_screen':(context) => const LoginScreen(),
//         '/profile_page':(context) => const MyProfile(),
//       },
//     );
//   }
// }