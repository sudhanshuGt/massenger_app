import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget profileOption({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  bool showSwitch = false,
  bool switchValue = false,
  ValueChanged<bool>? onSwitchChanged,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
          showSwitch
              ? Switch(
            value: switchValue,
            onChanged: onSwitchChanged,
          )
              : const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}
