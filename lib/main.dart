import 'package:fala/provider/subscription_provider.dart';
import 'package:fala/views/initialization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider())
      ],
      child: const Application(),
    )
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "FaLa",
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    navigatorKey: navigatorKey,
    home: InitializationView(),
  );
}
