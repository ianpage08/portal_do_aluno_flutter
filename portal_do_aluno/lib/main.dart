import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/app.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/exercicio_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/core/services/notification_service_remote.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/firebase/firebase_options.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/presenca_provider.dart';
import 'package:portal_do_aluno/core/notifications/notification_service_local.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationServiceRemote().init();
  await NotificationService().init();

  ExercicioSevice().excluirPorDataexpiracao();

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PresencaProvider()),
        ChangeNotifierProvider(create: (_) => SelectedProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:const  MyApp(
        
      ),
    ),
  );
}
