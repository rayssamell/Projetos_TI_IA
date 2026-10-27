import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path_utils;
import 'package:truecook/shared/utils/constants.dart';

class ImageUploader {
  /// Faz upload da imagem.
  /// [onProgress] é uma função opcional que recebe a porcentagem (0.0 a 1.0)
  static Future<String> uploadImage({
    required File imageFile,
    String titulo = "imagem",
    String folderPath = "receitas",
    void Function(double progress)? onProgress,
  }) async {
    // 1. Validação inicial
    if (!await imageFile.exists()) {
      print("⚠️ Arquivo não encontrado");
      return AppAssets.DefaultImage;
    }

    try {
      final String safeTitle = titulo
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .trim();
      final String extension = path_utils.extension(imageFile.path);
      final String fileName =
          '$safeTitle-${DateTime.now().millisecondsSinceEpoch}$extension';

      final storageRef = FirebaseStorage.instance.ref().child(
        '$folderPath/$fileName',
      );

      final metadata = SettableMetadata(
        contentType: 'image/${extension.replaceAll('.', '')}',
        customMetadata: {'tituloOriginal': titulo},
      );

      print("🚀 Iniciando upload...");

      // 2. Cria a Tarefa de Upload (mas não espera ela acabar ainda)
      final uploadTask = storageRef.putFile(imageFile, metadata);

      // 3. Escuta o fluxo de eventos para calcular a porcentagem
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Calcula progresso (ex: 0.5 é 50%)
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;

        print("📊 Upload: ${(progress * 100).toStringAsFixed(0)}%");

        // Se quem chamou a função passou um callback, avisa ele
        if (onProgress != null) {
          onProgress(progress);
        }
      });

      // 4. Espera o upload terminar de fato
      await uploadTask;

      // 5. Pega a URL final
      final imageUrl = await storageRef.getDownloadURL();

      print('✅ Upload concluído: $imageUrl');
      return imageUrl;
    } on FirebaseException catch (e) {
      print('❌ Erro no Firebase: ${e.code}');
      return AppAssets.DefaultImage;
    } catch (e) {
      print('❌ Erro genérico: $e');
      return AppAssets.DefaultImage;
    }
  }
}
