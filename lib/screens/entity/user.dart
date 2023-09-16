class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final firstname = json['firstname'];
    final lastname = json['lastname'];
    final email = json['email'];

    if (id == null || firstname == null || lastname == null || email == null) {
      throw FormatException("Invalid user data");
    }

    return User(
      id: id,
      firstname: firstname,
      lastname: lastname,
      email: email,
    );
  }
}
