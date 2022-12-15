class User{
  int? id;
  String? name;
  String? email;
  String? contact;
  String? photo;
  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['email'] = email!;
    mapping['contact'] = contact!;
    mapping['photo'] = photo!;
    return mapping;
  }
}