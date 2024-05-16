import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id(assignable: true)
  int id;

  String? gender;
  String fullName; // Combined first name and last name
/*  String? streetName;
  int? streetNumber;
  String? city;
  String? state;
  String? country;
  int? postcode;
  double? latitude;
  double? longitude;
  String? timezoneOffset;
  String? timezoneDescription;
  String? email;
  String? username;
  String? password;
  String? salt;
  String? md5;
  String? sha1;
  String? sha256;
  DateTime? dob;*/
  int age;
 /* DateTime? registeredDate;
  int? registeredAge;
  String? phone;
  String? cell;
  String? idName;
  String? idValue;
  String? pictureLarge;
  String? pictureMedium;
  String? pictureThumbnail;
  String? nat;*/
  bool isSelected = false;

  User({
    this.id = 0,
    this.gender,
    required this.fullName,
  /*  this.streetName,
    this.streetNumber,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.latitude,
    this.longitude,
    this.timezoneOffset,
    this.timezoneDescription,
    this.email,
    this.username,
    this.password,
    this.salt,
    this.md5,
    this.sha1,
    this.sha256,
    this.dob,*/
    required this.age,
    /*this.registeredDate,
    this.registeredAge,
    this.phone,
    this.cell,
    this.idName,
    this.idValue,
    this.pictureLarge,
    this.pictureMedium,
    this.pictureThumbnail,
    this.nat,*/
    this.isSelected = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      gender: json['gender'],
      fullName: '${json['name']['title']} ${json['name']['first']} ${json['name']['last']}',
     /* streetName: json['location']['street']['name'],
      streetNumber: json['location']['street']['number'],
      city: json['location']['city'],
      state: json['location']['state'],
      country: json['location']['country'],
      postcode: json['location']['postcode'],
      latitude: double.parse(json['location']['coordinates']['latitude']),
      longitude: double.parse(json['location']['coordinates']['longitude']),
      timezoneOffset: json['location']['timezone']['offset'],
      timezoneDescription: json['location']['timezone']['description'],
      email: json['email'],
      username: json['login']['username'],
      password: json['login']['password'],
      salt: json['login']['salt'],
      md5: json['login']['md5'],
      sha1: json['login']['sha1'],
      sha256: json['login']['sha256'],
      dob: DateTime.parse(json['dob']['date']),*/
      age: json['dob']['age']??0,
      /*registeredDate: DateTime.parse(json['registered']['date']),
      registeredAge: json['registered']['age'],
      phone: json['phone'],
      cell: json['cell'],
      idName: json['id']['name'],
      idValue: json['id']['value'],
      pictureLarge: json['picture']['large'],
      pictureMedium: json['picture']['medium'],
      pictureThumbnail: json['picture']['thumbnail'],
      nat: json['nat'],*/
      isSelected: false,
    );
  }
}
