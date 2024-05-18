import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:servio/backend/firebase_auth/get_userdata.dart';
import 'package:servio/backend/mysql/orders/order_controller.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/firebase_options.dart';
import 'package:servio/frontend/pages/auth/edit_profile.dart';
import 'package:servio/frontend/pages/auth/login_regist.dart';
import 'package:servio/frontend/pages/home.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);
  await getOrderData();
  runApp(const StartApp());
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  Future<FirebaseApp> initilazeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true),
            primaryColor: primaryColor),
        color: primaryColor,
        home: StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              user = snapshot.data;
              displayName = '${user!.displayName}';
              email = '${user!.email}';
              if (displayName == 'null') {
                setUserdataOnEditProfilePage();
                return const EditProfile();
              } else {
                return const HomePage();
              }
            }
            return const AuthPage();
          },
        ));
  }
}

//TO-DO: when Order deleting than delete 