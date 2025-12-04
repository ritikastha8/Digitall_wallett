class Onboard {
  final String image;
  final String title;
  final String description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

// Sample data
final List<Onboard> demoData = [
  Onboard(
    image: "assets/images/onboardingmanagemoney.png",
    title: "Manage Money Easily",
    description:
        "Check wallet balance, load money, and track transactions instantly.",
  ),
  Onboard(
    image: "assets/images/onboardingQR.png",
    title: " Fast & Easy Payments",
    description:
        "Transfer money to anyone or scan QR codes for quick payments.",
  ),
  Onboard(
    image: "assets/images/onboardingsafe.png",
    title: " Safe & Secure",
    description: "Wallet is protected with PIN, encryption, and secure login.",
  ),
];
