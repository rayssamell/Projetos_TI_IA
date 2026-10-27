import 'package:flutter/material.dart';
import 'package:truecook/models/comentario.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/CommentBubbleClipper.dart';

class ComentariosScroll extends StatefulWidget {
  final List<Comentario> comentarios;
  final VoidCallback? onClose;
  final Function(String texto, double nota)? onEnviarComentario;

  const ComentariosScroll({
    super.key,
    required this.comentarios,
    this.onClose,
    this.onEnviarComentario,
  });

  @override
  State<ComentariosScroll> createState() => _ComentariosScroll();
}

class _ComentariosScroll extends State<ComentariosScroll> {
  final TextEditingController _controller = TextEditingController();
  double _notaSelecionada = 5;

  Widget _CardComentario(int index, Comentario comentario) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                comentario.usuario?.foto ?? AppAssets.DefaultImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ClipPath(
            clipper: CommentBubbleClipper(borderRadius: 15.0, tipSize: 15.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
              decoration: BoxDecoration(
                color: AppColors.allWhite,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comentario.usuario?.nome ?? "Anônimo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${comentario.data_publicacao.day.toString().padLeft(2, '0')}/"
                        "${comentario.data_publicacao.month.toString().padLeft(2, '0')}/"
                        "${comentario.data_publicacao.year}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    comentario.texto,
                    style: TextStyle(fontSize: 15),
                    softWrap: true,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < comentario.avaliacao
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(20),
        color: AppColors.orangeDefault,
        child: Column(
          children: [
            // Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Comentários",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            SizedBox(height: 10),
            // Lista de comentários
            Expanded(
              child: ListView.builder(
                itemCount: widget.comentarios.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: _CardComentario(index, widget.comentarios[index]),
                ),
              ),
            ),
            Divider(color: Colors.white),
            // Campo para escrever comentário + nota
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escreva um comentário...",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<double>(
                  value: _notaSelecionada,
                  dropdownColor: Colors.white,
                  items: List.generate(
                    5,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _notaSelecionada = value);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    final texto = _controller.text.trim();
                    if (texto.isNotEmpty && widget.onEnviarComentario != null) {
                      widget.onEnviarComentario!(texto, _notaSelecionada);
                      _controller.clear();
                      setState(() => _notaSelecionada = 5);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
