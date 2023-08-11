import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/firebase/firebase_options.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

void main() async {
  // Flutter 프레임워크가 완전히 부팅될 때까지 
  // 애플리케이션 위젯 코드 실행을 시작하지 않도록 Flutter에 지시합니다. 
  WidgetsFlutterBinding.ensureInitialized();

  // Google Key
  await dotenv.load(fileName: 'keys.env');

  // Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init DateFormat
  initializeDateFormatting();
  Intl.defaultLocale = 'ko_KR';

  runApp(const NuduwaApp());
}

class NuduwaApp extends StatelessWidget {
  const NuduwaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NUDUWA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRoute.router,
    );
  }
}
