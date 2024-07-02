# AddressFormEnhancer

AddressFormEnhancer is a Flutter application that enhances the traditional address form with features like autocomplete, form validation, API integration, and more. The app provides a user-friendly experience for entering and validating addresses.

## Features

1. **Autocomplete**: The `CustomTextFormField` widget supports autocomplete options for the first street address field. It displays a list of hardcoded address suggestions when the user types 2 or more characters. When the field contains less than 2 characters, no suggestions are displayed.

2. **Autocomplete Selection**: When the user taps an autocomplete suggestion, the form updates all relevant fields from the address object.

3. **Form Validation**: Simple form validation rules are implemented for the text fields in the form. The user must fill all the fields for the form to be considered valid.

4. **API Integration**: Simulates a real-world scenario where addresses are fetched from an external API. The delay to get address suggestions is set to 1 second.

## Bonus Features

1. **Debounce**: Implements debounce functionality for the autocomplete field. The field waits for 300ms before sending the request to the API. Whenever the user types again, the timer resets.

2. **Form Fields**: Improves form fields to limit the input length and allowed characters based on general USA address standards.

3. **Address State Selection**: Modifies `CustomTextFormField` to support dropdown options for selecting the state. The [us_states](https://pub.dev/packages/us_states) library is used to get the list of US states.

4. **Error Handling**: Implements error handling for the API request. Simulates an error scenario when the user types "error" into the autocomplete field.

5. **Submit Form**: Implements form submission functionality. When the user fills all the fields and taps the submit button, a loading indicator is displayed for 2 seconds, followed by a success message indicating that the address has been successfully updated.

6. **Keyboard Visibility**: Improves keyboard visibility functionality. When the user taps outside the fields, the keyboard hides.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Piyushhhh/AddressFormEnhancer.git
   cd AddressFormEnhancer

## Usage

### Street Address Autocomplete
Start typing in the first street address field to see autocomplete suggestions. Select a suggestion to auto-fill the address fields.

### Form Validation
Ensure all fields are filled to submit the form. The form will display validation errors if any field is left empty.

### Submit Form
Fill in all the fields and tap the submit button to see the loading indicator and success message.

### Keyboard Visibility
Tap outside the input fields to hide the keyboard.


## Screenshots

- **Home page iPhone 15 Pro Max (390x844 pixels)**
<img src="https://github.com/Piyushhhhh/AddressFormEnhancer/blob/main/Screenshot/Home.png" height="700" >


- **Walk-throuh Video iPhone 15 Pro Max (390x844 pixels)**
  
https://github.com/Piyushhhhh/AddressFormEnhancer/assets/40383768/465013de-5e3f-4923-8f3a-6242de36e887


