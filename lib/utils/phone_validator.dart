import 'package:form_field_validator/form_field_validator.dart';

class PhoneValidator extends TextFieldValidator {
  PhoneValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    if (value?[0] != "+") {
      return false;
    }
    return true;
  }
}

class LineLengthValidator extends TextFieldValidator {
  LineLengthValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    final String bioValue = value ?? "";
    if ((bioValue.trim()).split("\n").length > 6) {
      return false;
    }
    return true;
  }
}
