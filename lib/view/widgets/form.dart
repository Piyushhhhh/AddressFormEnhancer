import 'package:benjamin/controller/address_form_controller.dart';
import 'package:benjamin/model/address.dart';
import 'package:benjamin/view/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:us_states/us_states.dart';

Widget buildForm(AddressController addressFormController, Key formKey) {
  return Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            labelText: "Street address",
            suggestions: addressSuggestions.map((e) => e.address).toList(),
            validator: (value) {
              if (value?.isEmpty == true) {
                return "Address cannot be empty";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            labelText: "Street address line 2",
            textEditingController:
                addressFormController.secondLineAddressController,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Address cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  textEditingController: addressFormController.cityController,
                  labelText: "City",
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'City cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextFormField(
                  labelText: "Zip",
                  textEditingController: addressFormController.zipController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Zip cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            labelText: "State",
            dropdownItems: USStates.getAllNames(),
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'State cannot be empty';
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );
}
