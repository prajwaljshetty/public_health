import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/locale_controller.dart';

// Transition
import 'package:public_health/Language/language_transition.dart';

// Bridge
import 'package:public_health/bridge.dart';

// Providers
import 'package:public_health/Providers/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

// Map :
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:public_health/config/mapbox_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await localeController.load();

  MapboxOptions.setAccessToken(MapboxConfig.accessToken);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PickupRequestProvider()),
      ],
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

        builder: (context, child) {
          return LanguageTransition(child: child!);
        },
      ),
    );
  }
}
