import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart'; // Para autenticação com a Service Account do Firebase
import 'package:http/http.dart' as http; // Para fazer requisições HTTP

// Função que pega o Access Token OAuth2 da sua Service Account

Future<String> getAccessToken() async {
  const String serviceAccountJson = r'''
{
  "type": "service_account",
  "project_id": "banco-de-usuarios-alunos",
  "private_key_id": "70ffadcd7b89858e9b32ef93c9de6609648a38b8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANB ... \n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@banco-de-usuarios-alunos.iam.gserviceaccount.com",
  "client_id": "107701978309369659971",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc@banco-de-usuarios-alunos.iam.gserviceaccount.com"
}
''';

  // Converte o JSON da Service Account em credenciais
  final credenciais = ServiceAccountCredentials.fromJson(serviceAccountJson);

  // Define o escopo necessário para enviar mensagens FCM
  final scope = ['https://www.googleapis.com/auth/firebase.messaging'];

  // Cria um cliente autenticado com a Service Account
  final authClient = await clientViaServiceAccount(credenciais, scope);

  // Pega o Access Token que vai ser usado na requisição
  final token = authClient.credentials.accessToken;

  return token.data; // Retorna o token em String
}

// Função que envia a notificação para um token FCM específico
Future<void> enviarNotification(
  String token, // token FCM do dispositivo que vai receber a notificação
  String title, // título da notificação
  String message, // corpo da notificação
) async {
  final accessToken = await getAccessToken(); // Pega o token OAuth2

  // URL da API HTTP v1 do Firebase Messaging
  final url = Uri.parse(
    'https://fcm.googleapis.com/v1/projects/banco-de-usuarios-alunos/messages:send',
  );

  // Monta o corpo da requisição JSON
  final body = jsonEncode({
    'message': {
      'token': token, // Destinatário da notificação
      'notification': {
        'title': title,
        'body': message,
      }, // Dados visuais da notificação
      'android': {'priority': 'high'}, // Prioridade no Android
      'apns': {
        'headers': {'apns-priority': '10'}, // Prioridade no iOS
      },
    },
  });
  debugPrint('Access token: $accessToken');

  // Envia a requisição POST para a API FCM
  final responsta = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken', // Autenticação usando o token
      'Content-Type': 'application/json; charset=UTF-8', // JSON
    },
    body: body,
  );

  // Verifica se deu certo
  if (responsta.statusCode == 200) {
    debugPrint('Notificação enviada com sucesso');
  } else {
    debugPrint('Erro ao enviar notificação: ${responsta.statusCode}');
  }
}
