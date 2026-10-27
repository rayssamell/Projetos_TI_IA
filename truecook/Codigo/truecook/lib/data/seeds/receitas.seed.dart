// Seeds de Receitas
import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedReceitas(Database db) async {
  print('🌱 Rodando seeds Receitas...');

  await db.insert(AppTables.RECEITA, {
    'titulo': 'Bolo de Cenoura sem Glúten',
    'descricao': 'Um bolo fofinho de cenoura sem glúten, ideal para celíacos.',
    'imagem':
        'https://bakeandcakegourmet.com.br/uploads/site/receitas/bolo-de-cenoura-sem-gluten-ghqgbkkh.jpg',
    'passo_a_passo':
        'Bata no liquidificador cenouras, ovos e óleo.\nMisture com farinha de arroz, açúcar e fermento.\nLeve ao forno por 40 minutos.',
    'tempo_preparo': 50,
    'data_publicacao': '2025-09-01',
    'usuario_id': 1,
    'observacoes':
        'Pode substituir o açúcar por xilitol.\nFica ótimo com cobertura de chocolate 70%.',
  });

  await db.insert(AppTables.RECEITA, {
    'titulo': 'Panqueca Vegana de Banana',
    'descricao': 'Panqueca nutritiva feita com banana, aveia e sem ovos.',
    'imagem':
        'https://newmillen.com.br/wp-content/uploads/2020/02/Panqueca-de-Banana-Vegana-1.jpg',
    'passo_a_passo':
        'Amasse as bananas e misture com aveia e leite vegetal.\nAqueça a frigideira antiaderente.\nColoque pequenas porções e cozinhe até dourar.',
    'tempo_preparo': 20,
    'data_publicacao': '2025-09-02',
    'usuario_id': 2,
    'observacoes':
        'Pode adicionar canela em pó para mais sabor.\nServir com melado ou geleia.',
  });

  await db.insert(AppTables.RECEITA, {
    'titulo': 'Salada de Grão-de-Bico Mediterrânea',
    'descricao': 'Salada refrescante e rica em proteínas vegetais.',
    'imagem':
        'https://www.comidaereceitas.com.br/wp-content/uploads/2025/01/salada-mediterranea-de-rao-de-bico-780x517.jpg',
    'passo_a_passo':
        'Cozinhe o grão-de-bico até ficar macio.\nAdicione tomate, pepino, cebola roxa e azeite.\nTempere com limão, sal e ervas frescas.',
    'tempo_preparo': 15,
    'data_publicacao': '2025-09-03',
    'usuario_id': 3,
    'observacoes':
        'Deixe o grão-de-bico de molho por 12h para cozinhar mais rápido.\nPode adicionar azeitonas pretas para intensificar o sabor.',
  });

  await db.insert(AppTables.RECEITA, {
    'titulo': 'Sopa Detox de Abóbora',
    'descricao': 'Sopa cremosa, leve e sem lactose.',
    'imagem':
        'https://s2.glbimg.com/jkZj3gYudddKlo0kalbpWwdJQT8=/620x455/e.glbimg.com/og/ed/f/original/2018/08/13/sopa_de_abobora.jpg',
    'passo_a_passo':
        'Refogue cebola e alho em azeite.\nAdicione a abóbora em cubos e cozinhe com água.\nBata no liquidificador e finalize com temperos.',
    'tempo_preparo': 35,
    'data_publicacao': '2025-09-04',
    'usuario_id': 4,
    'observacoes':
        'Pode congelar em porções individuais.\nFica ótimo com gengibre fresco.',
  });

  await db.insert(AppTables.RECEITA, {
    'titulo': 'Muffin Integral de Maçã e Canela',
    'descricao': 'Muffins integrais sem lactose e com açúcar mascavo.',
    'imagem':
        'https://blog.barano.com.br/wp-content/uploads/2024/07/Receita-Muffin-Integral-de-Maca-com-Canela-1600x1000-1.jpg',
    'passo_a_passo':
        'Misture farinha integral, açúcar mascavo e fermento.\nAdicione maçã ralada, óleo de coco e leite vegetal.\nAsse em formas de muffin por 25 minutos.',
    'tempo_preparo': 40,
    'data_publicacao': '2025-09-05',
    'usuario_id': 5,
    'observacoes':
        'Melhor consumir ainda morno.\nPode substituir a maçã por pera.',
  });

  print('✅ Receitas inseridas.');
}
