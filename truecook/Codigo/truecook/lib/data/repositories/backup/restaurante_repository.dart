// lib/data/restaurante_repository.dart

// <--- This must be latlong2
import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/shared/enums/enumTables.dart';
import '../../../models/comercio.dart';

class ComercioRepository extends CrudRespository<Comercio> {
  ComercioRepository() : super(tableName: AppTables.COMERCIO);

  Future<List<Comercio>> fetchComercios() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Comercio(
        id: 1,
        nome: 'Migalha',
        tipo: 'Padaria/Cafeteria',
        localizacao: 'Rua das Oliveiras, 123 - São Paulo, SP',
        descricao:
            'Padaria especializada em produtos sem glúten e veganos, oferecendo pães, bolos e salgados para celíacos e veganos.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.5,
        horarioFuncionamento:
            'Segunda a Sábado: 07:00 - 20:00 | Domingo: 08:00 - 18:00',
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      Comercio(
        id: 2,
        nome: 'Recanto GF',
        tipo: 'Restaurante',
        localizacao: 'Avenida Paulista, 500 - São Paulo, SP',
        descricao:
            'Restaurante focado em culinária sem glúten e sem lactose, com opções variadas para almoço e jantar.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.8,
        horarioFuncionamento:
            'Terça a Domingo: 11:00 - 23:00 | Segunda: Fechado',
        latitude: -23.5613,
        longitude: -46.6567,
      ),
      Comercio(
        id: 3,
        nome: 'Alvarenga',
        tipo: 'Mercado Orgânico',
        localizacao: 'Rua Bela Cintra, 456 - São Paulo, SP',
        descricao:
            'Mercado especializado em produtos orgânicos e veganos, com grande variedade de frutas, verduras e produtos naturais.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.2,
        horarioFuncionamento:
            'Segunda a Sábado: 08:00 - 22:00 | Domingo: 08:00 - 20:00',
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      Comercio(
        id: 4,
        nome: 'SaboresDeMaria',
        tipo: 'Café/Restaurante',
        localizacao: 'Rua Augusta, 789 - São Paulo, SP',
        descricao:
            'Estabelecimento aconchegante especializado em culinária sem glúten e sem lactose, perfeito para café da manhã e lanches.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.7,
        horarioFuncionamento: 'Todos os dias: 07:00 - 22:00',
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      Comercio(
        id: 5,
        nome: 'GlutenFree',
        tipo: 'Restaurante Especializado',
        localizacao: 'Avenida Faria Lima, 1000 - São Paulo, SP',
        descricao:
            'Restaurante 100% sem glúten, com cardápio diversificado incluindo massas, pizzas e sobremesas para celíacos.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.9,
        horarioFuncionamento:
            'Segunda a Sábado: 12:00 - 00:00 | Domingo: 12:00 - 22:00',
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      Comercio(
        id: 6,
        nome: 'Natural Life',
        tipo: 'Restaurante Vegano',
        localizacao: 'Rua Haddock Lobo, 200 - São Paulo, SP',
        descricao:
            'Restaurante 100% vegano com opções orgânicas e pratos inspirados na culinária internacional.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.6,
        horarioFuncionamento:
            'Terça a Domingo: 11:30 - 22:30 | Segunda: Fechado',
        latitude: -23.5550,
        longitude: -46.6600,
      ),
      Comercio(
        id: 7,
        nome: 'Casa da Quinoa',
        tipo: 'Loja de Produtos Naturais',
        localizacao: 'Alameda Santos, 800 - São Paulo, SP',
        descricao:
            'Loja especializada em produtos sem glúten, sem lactose e orgânicos, com atendimento personalizado.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.4,
        horarioFuncionamento:
            'Segunda a Sexta: 09:00 - 19:00 | Sábado: 09:00 - 17:00',
        latitude: -23.5570,
        longitude: -46.6580,
      ),
      Comercio(
        id: 8,
        nome: 'Doce Liberdade',
        tipo: 'Confeitaria',
        localizacao: 'Rua Oscar Freire, 350 - São Paulo, SP',
        descricao:
            'Confeitaria especializada em doces sem glúten, sem lactose e veganos, com bolos, tortas e sobremesas.',
        foto:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400&h=300&fit=crop&auto=format',
        avaliacao: 4.8,
        horarioFuncionamento:
            'Terça a Domingo: 10:00 - 20:00 | Segunda: Fechado',
        latitude: -23.5580,
        longitude: -46.6690,
      ),
    ];
  }
}
