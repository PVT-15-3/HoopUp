class User {
  String username;
  int skillLevel;
  int id;
  String email;

  User(this.username, this.skillLevel, this.id, this.email) {
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level must be between 0 and 5');
    }
  }
  // getters and setters for the class properties 
  getUsername() => username;
  getSkillLevel() => skillLevel;
  setSkillLevel(skillLevel) { 
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level must be between 0 and 5');
    } this.skillLevel = skillLevel;
  }
  getId() => id;
  getEmail() => email;
  setEmail(String email) => this.email = email;
}