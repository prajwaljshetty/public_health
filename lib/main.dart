import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/locale_controller.dart';

// Bridge
import 'package:public_health/bridge.dart';

// Providers
import 'package:public_health/Providers/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await localeController.load();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) => CupertinoApp(
        debugShowCheckedModeBanner: false,

        locale: localeController.locale,

        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],

        supportedLocales: AppLocalizations.supportedLocales,

        home: const Bridge(),
      ),
    );
  }
}
