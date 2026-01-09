typedef Validator = String? Function(String? value);

typedef DateValidator = String? Function(DateTime? value);

typedef DropDownValidator = String? Function(Object? value);

class Validators {
  static DropDownValidator dropDownRequire(String fieldName) {
    return (value) {
      if (value == null || value.toString().trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

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

  static DateValidator dateRequired(String fieldName) {
    return (value) {
      if (value == null) {
        return 'Please select date';
      }
      return null;
    };
  }

  static DateValidator dateValidator(String fieldName, bool isAllowToday) {
    return (value) {
      if (value == null) {
        return 'Please select date';
      }
      final today = DateTime.now();
      final selectedDate = DateTime(value.year, value.month, value.day);
      final currentDate = DateTime(today.year, today.month, today.day);

      if (isAllowToday) {
        if (selectedDate.isBefore(currentDate)) {
          return 'Please select today or a future date';
        }
      } else {
        if (!selectedDate.isAfter(currentDate)) {
          return 'Please select a future date';
        }
      }
      return null;
    };
  }

  static DateValidator updateDateValidator(
    String fieldName,
    DateTime dateStarted,
  ) {
    return (value) {
      if (value == null) {
        return 'Please select date';
      }
      final selectedDate = DateTime(value.year, value.month, value.day);

      if (dateStarted.isAfter(selectedDate)) {
        return 'Please select a future date';
      }
      return null;
    };
  }
}
