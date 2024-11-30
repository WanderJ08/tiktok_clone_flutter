import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Account Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
