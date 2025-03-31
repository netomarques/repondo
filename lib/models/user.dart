class User {
  final String id;
  final String email;
  final String role;

  User({required this.id, required this.email, required this.role});

  // Método para criar a instância do usuário a partir de um mapa de dados
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      email: data['email'],
      role: data['role'],
    );
  }

  // Método para converter a instância para mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }
}
