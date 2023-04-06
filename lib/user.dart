//Hej hej :)
class User {
  String username;
  int skillLevel;
  int id;
  String email;

  User(this.username, this.skillLevel, this.id, this.email) {
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level must be between 0 and 10');
    }
  }
}
