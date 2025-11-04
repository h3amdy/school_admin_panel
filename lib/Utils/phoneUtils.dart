bool isValidPhoneNumber(String phone) {
  final RegExp regex = RegExp(r'^[\d\+\-\(\)  ]{7,15}$');
  return regex.hasMatch(phone);
}
