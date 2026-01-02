import 'package:flutter/material.dart';

class HomesScreen extends StatelessWidget {
  const HomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // --- Section Title ---
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Roboto Semibold",
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 30),
            // --- Balance Card ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD87920),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.account_balance_wallet, size: 32),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NPR XXX.XX",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Balance", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),

            // --- Section Title ---
            const Padding(
              padding: EdgeInsets.only(left: 34),
              child: const Text(
                "Operations",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Roboto Semibold",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Operations Grid ---
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Button 1
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.download, size: 28),
                      SizedBox(height: 6),
                      Text("Load\nMoney", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 2
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload, size: 28),
                      SizedBox(height: 6),
                      Text("Send\nMoney", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 3
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, size: 28),
                      SizedBox(height: 6),
                      Text("My QR", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 4
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone_android, size: 28),
                      SizedBox(height: 6),
                      Text("Topup\n& Data", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 5
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_scanner, size: 28),
                      SizedBox(height: 6),
                      Text("QR\nScanner", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
