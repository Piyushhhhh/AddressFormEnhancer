import 'package:benjamin/model/address.dart';
import 'package:flutter/material.dart';

class AddressController extends ChangeNotifier {
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController secondLineAddressController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  Address filteredSuggestion =
      Address(address: '', city: '', secondLineAddress: '', zip: '');

  void updateStreet(String value) {
    streetController.text = value;
    notifyListeners();
  }

  void updateEntireAdress(String suggested) {
    filteredSuggestion = addressSuggestions
        .firstWhere((element) => element.address.contains(suggested));
    cityController.text = filteredSuggestion.city;
    secondLineAddressController.text = filteredSuggestion.secondLineAddress;
    zipController.text = filteredSuggestion.zip;
    notifyListeners();
  }

  void updateState(String value) {
    stateController.text = value;
    notifyListeners();
  }
}
