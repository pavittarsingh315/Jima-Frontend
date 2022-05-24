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
