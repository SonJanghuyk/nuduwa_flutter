import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/Repository/authentication_repository.dart';
import 'package:nuduwa_flutter/app/nuduwa_app/bloc_observer.dart';
import 'package:nuduwa_flutter/firebase/firebase_options.dart';
import 'package:nuduwa_flutter/app/nuduwa_app/view/nuduwa_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  // Get Google Key
  await dotenv.load(fileName: 'keys.env');

  // Init DateFormat
  initializeDateFormatting();
  Intl.defaultLocale = 'ko_KR';

  // Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(
    NuduwaApp(
      authenticationRepository: authenticationRepository,
    ),
  );
}
