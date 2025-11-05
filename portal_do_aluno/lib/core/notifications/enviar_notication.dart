import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// Pega o Access Token OAuth2 da Service Account para autenticar no FCM
Future<String> getAccessToken() async {
  const String serviceAccountJson = '''
{
  "type": "service_account",
  "project_id": "banco-de-usuarios-alunos",
  "private_key_id": "67d8c425bb4f6755315ccb4ba714d6f0107e8108",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCw88pqdPCqPpM8\\n9OF3tVZxzUHKwHRgQeIG/4a0q7oCVoQcEzFUfCS+owHR2aAIeLqD19C035ZdcH1P\\nqGFXgyiSK5S4YcK/KaCiTbvdfdFB/7OJWQhx9wuY5ggpkW2vXM0nHw0AeGgtr5+Y\\nc+bYS/QH00rKSEPMcxL76HHmxYGiuimrQ/g/njB2eMeYsRmpUFK9JLB8tqdAxgZ7\\noOJv5VMHcN/cnpa1Fh3SQ6Eot0YgNAUa9lf9swu+EOLVuzoVivfwaEZ7Xq7MzfXc\\n6aZ4pkfxkwj8JOFRjYmj07x5ick1a3OFVwID5lu1cdqcJrdzPgdjSAEs/cnmF6IR\\nYgbbO9EFAgMBAAECggEAM7Lumz7SR7MjmoYjT7HD8VjaVY34El19V7UVWrjnjiJP\\n09IJshjZNXdzoyeVmZQITlfiCs5eZKtmeT0FP6e61UX1XA938hkL7Q+QCUzmtAUs\\no77G+GEI2uGuVdK+/KK876ajSlVjfqGWm9iVA/Hg+N5TNhl58YRXchD+IkHnN672\\nL83D4H10AwSRPBo6UIGbTXMU2yVYMqkuP93cQcWVuyIh1QcHc6Yd3dtPEdvY0Nh2\\n4J9R/zeMNRVJgQ+ehB4d9Ms6GzHTbc97KPFKv6xe+P7hWUKBXoSwU7Fo6ve7NKre\\nmrsznXUqrpbk8cbXfKxR+zqRShsbiSR7+RfO2J5e+wKBgQDuPKVfD5MsilWl5OAw\\nMpJuTb6IinPCoi4wraqrdb2ZgGD9sRqmWsX3qtScEAMkJjTeFzDuFtW8OF3W5uL7\\njVnak/v+lUnQNDv4DVXpsB4ZecmwgD00gVCD18j+96v28s6kZ7kelPC7sANGUoHj\\nmdzFIUF8T0kgF8Ch86GHi4zMIwKBgQC+JV+LJw3WGquKkR8nV98qdY6z7RIztYK+\\n0HsEKAyoRwrKPg+wHWD+sXLfFWpvf9Ghshk4o9PHZtJblFeeQduWJVRzSrKSih5e\\neDEvdsskhcKQACe8M60ZC2l9v3ddk2mXj/xDCGAN4odhRBCV2Jf6zv2B6LJ3//SL\\nA9Zbnw7MtwKBgBTRieX/t225/PgNQyYTFUa8Vn0aFDma8IxicLqhBFuIo3En69tD\\nrW8SJ5gnsg6TpCUQQ79akXzsNA8WiBlRZdu6+NdrdlLSbbckezB7qnWxddWNr0uK\\nTV3oGnFldUqUN0iYo82vWEYegHrBtQYNqQQ0/sL9Lre2O6grYR82K6yfAoGBAIhM\\nvfo/mnl5ULHZaR2IrZ3/+rUbIUsTt48UXroSA1C07BUg+5ng1WB8zrz+2vbmBt0D\\nj3S8atiq6etfoJb+2mr8g1bJmsvUWgSZ35gIbYHWqCsVEWalHFWxioLrNqNLQgu0\\n2L0sSb5qPWUJp2Hiir7slWgD57qBLUhhDc1LbQ5tAoGBANFYBtNS+nKF7nBuD6P8\\n142eztUIiSbvR2zfG5b7Jn7izRifXJn2bSx4or8fTCZUcbmVY08FBJqLxQWZ6lIt\\npRgDqbdCnSwBoQhuOHYgjcHhdbTqM/Jd1VZuXykF0t262ATXBRGGlLSYcsE+zrIz\\nZDWyD+nhFfgFTF8hUALGUYvQ\\n-----END PRIVATE KEY-----\\n",
  "client_email": "firebase-adminsdk-fbsvc@banco-de-usuarios-alunos.iam.gserviceaccount.com",
  "client_id": "107701978309369659971",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40banco-de-usuarios-alunos.iam.gserviceaccount.com"
}
''';

  try {
    // Decodifica o JSON da service account
    final Map<String, dynamic> data = jsonDecode(serviceAccountJson);

    // Corrige o formato da chave privada (remove as barras duplas)
    data['private_key'] = (data['private_key'] as String).replaceAll(
      r'\\n',
      '\n',
    );

    // Cria credenciais corretamente
    final credenciais = ServiceAccountCredentials.fromJson(jsonEncode(data));

    // Define escopo para enviar notificações FCM
    const scope = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Cria o client autenticado com as credenciais
    final authClient = await clientViaServiceAccount(credenciais, scope);

    // Retorna o token pronto pra uso
    return authClient.credentials.accessToken.data;
  } catch (e) {
    debugPrint('❌ Erro ao gerar token de acesso: $e');
    rethrow;
  }
}

/// Envia uma notificação via Firebase Cloud Messaging HTTP v1 API
Future<void> enviarNotification(
  String token,
  String title,
  String message,
) async {
  try {
    final accessToken = await getAccessToken();

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/banco-de-usuarios-alunos/messages:send',
    );

    final body = jsonEncode({
      'message': {
        'token': token,
        'notification': {'title': title, 'body': message},
        'android': {'priority': 'high'},
        'apns': {
          'headers': {'apns-priority': '10'},
        },
      },
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
    } else {
      debugPrint('❌ Erro ao enviar notificação: ${response.statusCode}');
      debugPrint('Detalhes: ${response.body}');
    }
  } catch (e) {
    debugPrint('❌ Erro ao enviar notificação: $e');
  }
}
