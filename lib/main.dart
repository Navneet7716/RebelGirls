import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/responsive/mobile_screen_layout.dart';
import 'package:rebel_girls/responsive/responsive_layout_screen.dart';
import 'package:rebel_girls/responsive/web_screen_layout.dart';
import 'package:rebel_girls/screens/login_screen.dart';
import 'package:rebel_girls/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['apiKey'] as String,
        appId: dotenv.env['appId'] as String,
        messagingSenderId: dotenv.env['messagingSenderId'] as String,
        projectId: dotenv.env['projectId'] as String,
        storageBucket: dotenv.env['storageBucket'] as String,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryButtonColor,
          ),
        ),
        title: 'Rebel Girls',
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else {
                return const LoginScreen();
              }
            }

            // means connection to future hasnt been made yet

            ),
      ),
    );
  }
}
