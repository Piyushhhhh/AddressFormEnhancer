class Address {
  final String address;
  final String city;
  final String secondLineAddress;
  final String zip;

  Address({
    required this.address,
    required this.city,
    required this.secondLineAddress,
    required this.zip,
  });
}

List<Address> addressSuggestions = [
  Address(
    address: "123 Main St",
    city: "Springfield",
    secondLineAddress: "Apt 101",
    zip: "12345",
  ),
  Address(
    address: "123 Usual Mt",
    city: "NewTown",
    secondLineAddress: "Apt 108",
    zip: "12345",
  ),
  Address(
    address: "456 Oak Ave",
    city: "Riverside",
    secondLineAddress: "Suite 200",
    zip: "67890",
  ),
  Address(
    address: "789 Elm Blvd",
    city: "Lexington",
    secondLineAddress: "Unit B",
    zip: "54321",
  ),
  Address(
    address: "101 Pine Rd",
    city: "Portland",
    secondLineAddress: "Floor 3",
    zip: "98765",
  ),
];
