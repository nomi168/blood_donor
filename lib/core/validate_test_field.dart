String? validateFirstName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'First Name is required';
  } else if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
    return 'Only letters and spaces are allowed';
  } else if (value
      .split(' ')
      .any((word) => word.isNotEmpty && word[0].toUpperCase() != word[0])) {
    return 'Each word must start with a capital letter';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Last Name is required';
  } else if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
    return 'Only letters and spaces are allowed';
  } else if (value
      .split(' ')
      .any((word) => word.isNotEmpty && word[0].toUpperCase() != word[0])) {
    return 'Each word must start with a capital letter';
  }
  return null;
}

// ignore: unused_element
String? validatePhoneNumber(String value) {
  if (value.isEmpty) {
    return 'Phone number is required';
  } else if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
    return 'Only numbers are allowed';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
      .hasMatch(value)) {
    return 'Invalid email format';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters';
  } else if (!RegExp(r"^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\:{}|<>]).*$")
      .hasMatch(value)) {
    return 'Password must contain at least one number and one special character';
  }
  return null; // Indicates a valid password
}

String? validateLocation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Location is required';
  }
  return null; // Indicates a valid location
}

String? validateGender(String? value) {
  if (value == null || value.isEmpty) {
    return 'Gender is required';
  }
  return null; // Indicates a valid gender
}

String? validateBlood(String? value) {
  if (value == null || value.isEmpty) {
    return 'Blood is required';
  }
  return null; // Indicates a valid gender
}

String? validateHospital(String? value) {
  if (value == null || value.isEmpty) {
    return 'Hospital Name is required';
  }
  return null; // Indicates a valid location
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Address is required';
  }
  return null; // Indicates a valid location
}

String? validateNote(String? value) {
  if (value == null || value.isEmpty) {
    return 'Note is required';
  }
  return null; // Indicates a valid location
}
