import 'package:benjamin/controler/address_form_controler.dart';
import 'package:benjamin/model/address.dart';
import 'package:benjamin/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_states/us_states.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AddressController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    // Validate the form fields
    if (_formKey.currentState!.validate()) {
      // If valid, show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting form...')),
      );

      // Simulate a delay for 2 seconds to show loading
      Future.delayed(const Duration(seconds: 2), () {
        // After 2 seconds, show a success message and reset form
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );

        // Optional: Reset the form after submission
        _formKey.currentState!.reset();
      });
    }
  }

  Widget _buildForm(AddressController addressFormController) {
    return Form(
      key: _formKey,
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

  @override
  Widget build(BuildContext context) {
    final addressFormModel = Provider.of<AddressController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff002433),
        title: const Text("Benjamin", style: TextStyle(color: Colors.white)),
      ),
      body: _buildForm(addressFormModel),
      floatingActionButton: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff002433), elevation: 2),
        child: const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
