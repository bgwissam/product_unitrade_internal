class User {

  final String uid;

  User({this.uid});


}

class UserData {

  final String uid;
  final String firstName;
  final String lastName;
  final String company;
  final String phonNumber;
  final String emailAddress;
  final String countryOfResidence;
  final String cityOfResidence;
  final bool isAdmin;
  final bool isPriceAdmin;
  final bool isSuperAdmin;

  UserData({this.uid, this.firstName, this.lastName, this.company, this.phonNumber, this.emailAddress, this.countryOfResidence, this.cityOfResidence, this.isAdmin, this.isPriceAdmin, this.isSuperAdmin});

  
}

