import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/global.dart';

import '../service/google_auth_provider.dart';

class GoogleLoginScreen extends ConsumerWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(googleAuthProvider);
    final authNotifier = ref.read(googleAuthProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.error != null) {
        mySnackBar(message: authState.error!, context: context);
        Future.delayed(Duration(milliseconds: 100), () {
          authNotifier.clearError();
        });
      }
    });
    return Column(
      children: [
        MaterialButton(
          elevation: 0,
          color: Global.baseUrl == "Admin App" ? Colors.white : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: authState.isLoading
              ? null
              : () {
                  authNotifier.clearError();
                  authNotifier.signInWithGoogle(context);
                },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/archive/c/c1/20210313114223%21Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png",
                  height: 24,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                Text(
                  authState.isLoading ? "Signing in..." : "Sign in with Google",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (authState.isLoading)
          CircularProgressIndicator(
            color: Global.baseUrl == "Admin App" ? Colors.white : Colors.black,
          ),
      ],
    );
  }
}
