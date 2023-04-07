class Event {
final String name;
final String description; 
final String id;

Event(this.name, this.description, this.id);

// getters for the class properties
getName() => name;
getDescription() => description;
getId() => id;

Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'id': id
    };
  }
}