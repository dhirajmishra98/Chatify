// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OPTScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  OPTScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final TextEditingController otpController = TextEditingController();

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('Verifying your number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'We have sent an SMS with a code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                controller: otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 5,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(ref, context, value.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
