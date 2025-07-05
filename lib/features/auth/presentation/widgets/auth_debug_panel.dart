import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_theme.dart';

class AuthDebugPanel extends StatelessWidget {
  const AuthDebugPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Firebase Auth Debug Info:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Connection: ${snapshot.connectionState}'),
                  Text('Has User: ${user != null}'),
                  if (user != null) ...[
                    Text('Email: ${user.email}'),
                    Text('UID: ${user.uid}'),
                    Text('Email Verified: ${user.emailVerified}'),
                  ],
                  Text(
                    'Current User: ${FirebaseAuth.instance.currentUser?.email ?? 'None'}',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
