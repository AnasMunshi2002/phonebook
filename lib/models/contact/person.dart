class Person {
  int? id;
  final String? image;
  final String? prefix;
  final String firstname;
  final String? lastname;
  final bool? fav;
  late final bool? blocked;
  final String? birthday;
  final String addDate;
  final String phone;
  final String? email;
  final String? address;

  Person(
      {this.id,
      required this.addDate,
      this.image,
      this.fav,
      this.blocked,
      this.prefix,
      this.birthday,
      required this.firstname,
      required this.phone,
      this.email,
      this.address,
      this.lastname});

  Map<String, dynamic> toMap() {
    return {
      'prefix': prefix,
      'image': image,
      'firstname': firstname,
      'lastname': lastname,
      'favourite': (fav ?? false) ? 1 : 0,
      'blocked': (blocked ?? false) ? 1 : 0,
      'phone': phone,
      'email': email,
      'birthday': birthday,
      'addDate': addDate,
      'address': address,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      image: map['image'],
      prefix: map['prefix'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      fav: map['favourite'],
      blocked: map['blocked'],
      birthday: map['birthday'],
      addDate: map['addDate'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
    );
  }
}
