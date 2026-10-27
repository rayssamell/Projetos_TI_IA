// import 'package:truecook/data/repositories/comentarios_repository.dart';
// import 'package:truecook/data/repositories/igrediente_repository.dart';
// import 'package:truecook/models/comentario.dart';
// import 'package:truecook/models/ingrediente.dart';
// import 'package:truecook/models/receita.dart';

// /// Repositório responsável por gerenciar os dados de receitas.
// /// - Consulta API/ARRAY ou banco local.
// /// - Persistência de dados locais ou via API.

// final List<Receita> receitas = [
//   Receita(
//     id: 1,
//     titulo: "Bolo de Cenoura sem Glúten",
//     imagem:
//         "https://corsproxy.io/?https://bakeandcakegourmet.com.br/uploads/site/receitas/bolo-de-cenoura-sem-gluten-ghqgbkkh.jpg",
//     tags: ["LowCarb", "Celiaco", "Vegetariano", "Fitness"],
//     descricao: "Um bolo fofinho de cenoura sem glúten, ideal para celíacos.",
//     data_publicacao: DateTime(2025, 9, 1),
//     tempo_preparo: 50,
//     passo_a_passo: [
//       "Bata no liquidificador cenouras, ovos e óleo.",
//       "Misture com farinha de arroz, açúcar e fermento.",
//       "Leve ao forno por 40 minutos.",
//     ],
//     ingredientes: [
//       ingredientes[0], // Cenoura
//       ingredientes[2], // Ovo
//       ingredientes[1], // Farinha de Arroz
//       ingredientes[4], // Fermento
//     ],
//     avaliacoes: 4.5,
//     visualizacoes: 320,
//     observacoes: [
//       "Pode substituir o açúcar por xilitol.",
//       "Fica ótimo com cobertura de chocolate 70%.",
//     ],
//     comentarios: [
//       comentarios[0], // João
//       Comentario(
//         id: 6,
//         receitaId: 1,
//         userId: 4,
//         autor: "Ana",
//         comentario:
//             "Ficou delicioso! Acrescentei nozes e deu um toque especial.",
//         data: DateTime(2025, 9, 5),
//       ),
//     ],
//   ),
//   Receita(
//     id: 2,
//     titulo: "Panqueca Vegana de Banana",
//     imagem:
//         "https://corsproxy.io/?https://newmillen.com.br/wp-content/uploads/2020/02/Panqueca-de-Banana-Vegana-1.jpg",
//     tags: ["LowCarb", "Celiaco", "Vegetariano", "Fitness"],
//     descricao: "Panqueca nutritiva feita com banana, aveia e sem ovos.",
//     data_publicacao: DateTime(2025, 9, 2),
//     tempo_preparo: 20,
//     passo_a_passo: [
//       "Amasse as bananas e misture com aveia e leite vegetal.",
//       "Aqueça a frigideira antiaderente.",
//       "Coloque pequenas porções e cozinhe até dourar.",
//     ],
//     ingredientes: [
//       ingredientes[5], // Banana
//       ingredientes[6], // Aveia
//       ingredientes[7], // Leite Vegetal
//     ],
//     avaliacoes: 4.8,
//     visualizacoes: 500,
//     observacoes: [
//       "Pode adicionar canela em pó para mais sabor.",
//       "Servir com melado ou geleia.",
//     ],
//     comentarios: [
//       comentarios[1], // Maria
//       Comentario(
//         id: 7,
//         receitaId: 2,
//         userId: 5,
//         autor: "Carlos",
//         comentario: "Muito fácil de fazer, meu filho adorou no café da manhã.",
//         data: DateTime(2025, 9, 6),
//       ),
//     ],
//   ),
//   Receita(
//     id: 3,
//     titulo: "Salada de Grão-de-Bico Mediterrânea",
//     imagem:
//         "https://corsproxy.io/?https://www.comidaereceitas.com.br/wp-content/uploads/2025/01/salada-mediterranea-de-rao-de-bico-780x517.jpg",
//     tags: ["LowCarb", "Celiaco", "Vegetariano", "Fitness", "Vegano"],
//     descricao: "Salada refrescante e rica em proteínas vegetais.",
//     data_publicacao: DateTime(2025, 9, 3),
//     tempo_preparo: 15,
//     passo_a_passo: [
//       "Cozinhe o grão-de-bico até ficar macio.",
//       "Adicione tomate, pepino, cebola roxa e azeite.",
//       "Tempere com limão, sal e ervas frescas.",
//     ],
//     ingredientes: [
//       ingredientes[7], // Grão-de-bico
//       ingredientes[8], // Tomate
//       ingredientes[9], // Pepino
//       ingredientes[10], // Azeite
//       ingredientes[11], // Limão
//     ],
//     avaliacoes: 4.9,
//     visualizacoes: 620,
//     observacoes: [
//       "Deixe o grão-de-bico de molho por 12h para cozinhar mais rápido.",
//       "Pode adicionar azeitonas pretas para intensificar o sabor.",
//     ],
//     comentarios: [
//       comentarios[2], // Pedro
//       Comentario(
//         id: 8,
//         receitaId: 3,
//         userId: 6,
//         autor: "Fernanda",
//         comentario:
//             "Adorei! Coloquei um pouco de hortelã fresca e ficou incrível.",
//         data: DateTime(2025, 9, 7),
//       ),
//     ],
//   ),
//   Receita(
//     id: 4,
//     titulo: "Sopa Detox de Abóbora",
//     imagem:
//         "https://corsproxy.io/?https://s2.glbimg.com/jkZj3gYudddKlo0kalbpWwdJQT8=/620x455/e.glbimg.com/og/ed/f/original/2018/08/13/sopa_de_abobora.jpg",
//     tags: ["LowCarb", "Celiaco", "Vegetariano", "Fitness", "Vegano"],
//     descricao: "Sopa cremosa, leve e sem lactose.",
//     data_publicacao: DateTime(2025, 9, 4),
//     tempo_preparo: 35,
//     passo_a_passo: [
//       "Refogue cebola e alho em azeite.",
//       "Adicione a abóbora em cubos e cozinhe com água.",
//       "Bata no liquidificador e finalize com temperos.",
//     ],
//     ingredientes: [
//       ingredientes[13], // Abóbora
//       ingredientes[14], // Cebola
//       ingredientes[10], // Azeite
//     ],
//     avaliacoes: 3.5,
//     visualizacoes: 280,
//     observacoes: [
//       "Pode congelar em porções individuais.",
//       "Fica ótimo com gengibre fresco.",
//     ],
//     comentarios: [
//       Comentario(
//         id: 9,
//         receitaId: 4,
//         userId: 7,
//         autor: "Lucas",
//         comentario: "Sopa leve e deliciosa, perfeita para o jantar.",
//         data: DateTime(2025, 9, 8),
//       ),
//     ],
//   ),
//   Receita(
//     id: 5,
//     titulo: "Muffin Integral de Maçã e Canela",
//     imagem:
//         "https://corsproxy.io/?https://blog.barano.com.br/wp-content/uploads/2024/07/Receita-Muffin-Integral-de-Maca-com-Canela-1600x1000-1.jpg",
//     tags: ["LowCarb", "Celiaco", "Vegetariano", "Fitness"],
//     descricao: "Muffins integrais sem lactose e com açúcar mascavo.",
//     data_publicacao: DateTime(2025, 9, 5),
//     tempo_preparo: 40,
//     passo_a_passo: [
//       "Misture farinha integral, açúcar mascavo e fermento.",
//       "Adicione maçã ralada, óleo de coco e leite vegetal.",
//       "Asse em formas de muffin por 25 minutos.",
//     ],
//     ingredientes: [
//       ingredientes[15], // Maçã
//       ingredientes[16], // Açúcar Mascavo
//       ingredientes[17], // Óleo de Coco
//       ingredientes[6], // Aveia
//       ingredientes[4], // Fermento
//     ],
//     avaliacoes: 2.7,
//     visualizacoes: 410,
//     observacoes: [
//       "Melhor consumir ainda morno.",
//       "Pode substituir a maçã por pera.",
//     ],
//     comentarios: [
//       Comentario(
//         id: 10,
//         receitaId: 5,
//         userId: 8,
//         autor: "Juliana",
//         comentario: "Receita maravilhosa! Ficou fofinho e super aromático.",
//         data: DateTime(2025, 9, 9),
//       ),
//     ],
//   ),
// ];
