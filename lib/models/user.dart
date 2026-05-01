class Users {
  final String uid;
  final String? email;
  final String? photoURL;
  final bool emailVerified;

  Users({
    required this.uid,
    this.email,
    this.photoURL,
    required this.emailVerified,
  });
}