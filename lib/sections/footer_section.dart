import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          const Text(
            "Designed & Built with ❤️ by Kheamesh Soni",
            style: TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 10),
          const Text(
            "© 2024 All Rights Reserved",
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: const Text("Privacy Policy", style: TextStyle(color: Colors.white24))),
              const Text("|", style: TextStyle(color: Colors.white10)),
              TextButton(onPressed: () {}, child: const Text("Terms of Service", style: TextStyle(color: Colors.white24))),
            ],
          ),
        ],
      ),
    );
  }
}
