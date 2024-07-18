class Receiver {
  final String name;
  final String relationship;
  bool isActive;

  Receiver(
      {required this.name, required this.relationship, this.isActive = false});
}