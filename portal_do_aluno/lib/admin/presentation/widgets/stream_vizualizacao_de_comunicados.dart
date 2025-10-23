import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Widget para visualizar comunicados em tempo real usando um Stream.

class StreamVizualizacaoDeComunicados extends StatefulWidget {
  // Stream que fornece os dados dos comunicados do Firestore.
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream;

  const StreamVizualizacaoDeComunicados({
    super.key,
    required this.comunicadosStream,
  });

  @override
  State<StreamVizualizacaoDeComunicados> createState() =>
      _StreamVizualizacaoDeComunicadosState();
}

class _StreamVizualizacaoDeComunicadosState
    extends State<StreamVizualizacaoDeComunicados> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      // Escuta o stream passado como parâmetro para atualizar a UI em tempo real.
      stream: widget.comunicadosStream,
      builder: (context, snapshot) {
        // Estado de carregamento: mostra um indicador de progresso enquanto os dados são buscados.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Estado de erro: exibe uma mensagem de erro se houver problema no stream.
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        // Dados recebidos: lista de documentos de comunicados.
        final comunicado = snapshot.data!.docs;

        // Constrói uma lista rolável com os comunicados.
        return ListView.builder(
          // Número de itens na lista baseado na quantidade de documentos.
          itemCount: comunicado.length,
          itemBuilder: (context, index) {
            // Documento atual do comunicado.
            final comunicadoDoc = comunicado[index];

            // Extrai o título do documento, com fallback se não existir.
            final titulo = comunicadoDoc['titulo'] ?? 'Sem título';

            // Converte a data de publicação (Timestamp) para DateTime e formata.
            final dataPublicacao =
                (comunicadoDoc['dataPublicacao'] as Timestamp).toDate();
            final dataFormatada =
                '${dataPublicacao.day}/${dataPublicacao.month}/${dataPublicacao.year}';

            // Extrai a descrição/mensagem do documento, com fallback.
            final descricao = comunicadoDoc['mensagem'] ?? 'Sem descrição';

            // Retorna um Card para cada comunicado, com ícone, título, descrição e data.
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                // Ícone de mensagem no lado esquerdo.
                leading: Icon(
                  Icons.message,
                  color: Colors.deepPurpleAccent[200],
                ),

                // Título do comunicado.
                title: Text(titulo, style: const TextStyle(fontSize: 20)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Descrição do comunicado.
                    Text(descricao),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Data formatada no canto inferior direito.
                        Text(dataFormatada),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
