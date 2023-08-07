import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/router.dart';
import 'package:whatsapp_clone/screens/landing_screen.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Clone',
      theme: ThemeData(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              background: backgroundColor,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) return const LandingScreen();
            return const MobileScreenLayout();
          },
          error: (error, trace) {
            return ErrorScreen(error: error.toString());
          },
          loading: () => const Loader()),
    );
  }
}
