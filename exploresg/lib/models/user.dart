class UserModel {
  String id,
      username,
      firstName,
      lastName,
      email,
      picture,
      mobileNumber,
      interest,
      favourites;
  String? token;
  bool emailVerified, numberVerified;

  UserModel(
      this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.token,
      this.picture,
      this.mobileNumber,
      this.emailVerified,
      this.numberVerified,
      this.interest,
      this.favourites);

  void setId(String id) {
    this.id = id;
  }

  void setToken(String? token) {
    this.token = token;
  }

  void setEmailVerified(bool verified) {
    this.emailVerified = verified;
  }

  String getId() {
    return this.id;
  }

  String getUsername() {
    return this.username;
  }

  String getEmail() {
    return this.email;
  }

  String getFirstName() {
    return this.firstName;
  }

  String getLastName() {
    return this.lastName;
  }

  String getPicture() {
    return this.picture;
  }

  String getInterest() {
    return this.interest;
  }

  void setFirstName(String first) {
    this.firstName = first;
  }

  void setLastName(String last) {
    this.lastName = last;
  }

  void setPicture(String picture) {
    this.picture = picture;
  }

  UserModel.fromSnapshot(dynamic snapshot)
      : id = snapshot['id'],
        username = snapshot['username'],
        firstName = snapshot['firstName'],
        lastName = snapshot['lastName'],
        email = snapshot['email'],
        token = snapshot['token'],
        picture = snapshot['picture'],
        mobileNumber = snapshot['mobileNumber'],
        emailVerified = snapshot['emailVerified'],
        numberVerified = snapshot['numberVerified'],
        interest = snapshot['interest'],
        favourites = snapshot['favourites'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'token': token,
        'picture': picture,
        'mobileNumber': mobileNumber,
        'emailVerified': emailVerified,
        'numberVerified': numberVerified,
        'interest': interest,
        'favourites': favourites
      };
}
