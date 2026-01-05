typedef Validator = String? Function(String? value);

class Validators {
  static Validator required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  static Validator numbers(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      if (double.tryParse(value) == null) {
        return '$fieldName must be a valid number';
      }
      return null;
    };
  }
}
