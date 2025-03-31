class Despensa {
  final String id;
  final String nome;

  Despensa({required this.id, required this.nome});

  factory Despensa.fromMap(Map<String, dynamic> data) {
    return Despensa(
      id: data['id'],
      nome: data['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
