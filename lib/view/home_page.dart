import 'package:benjamin/controller/address_form_controller.dart';
import 'package:benjamin/values/strings.dart';
import 'package:benjamin/view/widgets/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final addressFormModel = Provider.of<AddressController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff002433),
        title:
            const Text(Strings.benjamin, style: TextStyle(color: Colors.white)),
      ),
      body: buildForm(addressFormModel, _formKey),
      floatingActionButton: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff002433), elevation: 2),
        child:
            const Text(Strings.submit, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
