import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

/// Deletes the signed-in Firebase Auth user (email/password) after reauthentication,
/// and removes their Firestore `users` doc plus related `quotes` / `reviews` rows.
class AccountDeletionService {
  AccountDeletionService._();

  static Future<void> deleteAccountWithPassword(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not signed in');
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw StateError(
        'This account has no email on file. Contact support to delete it.',
      );
    }

    final cred = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(cred);

    final uid = user.uid;
    final fs = FirebaseFirestore.instance;

    await _deleteQueryChunked(
      fs.collection('quotes').where('customerId', isEqualTo: uid),
    );
    await _deleteQueryChunked(
      fs.collection('quotes').where('vendorId', isEqualTo: uid),
    );
    await _deleteQueryChunked(
      fs.collection('reviews').where('customerId', isEqualTo: uid),
    );
    await _deleteQueryChunked(
      fs.collection('reviews').where('vendorId', isEqualTo: uid),
    );

    await fs.collection('users').doc(uid).delete();
    await user.delete();
  }

  static Future<void> _deleteQueryChunked(
    Query<Map<String, dynamic>> query,
  ) async {
    while (true) {
      final snap = await query.limit(450).get();
      if (snap.docs.isEmpty) break;

      final batch = FirebaseFirestore.instance.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }

  static String messageForError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-credential':
          return 'Could not verify your password. Try again.';
        case 'requires-recent-login':
          return 'Please sign out and sign in again, then retry.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return e.message?.isNotEmpty == true
              ? e.message!
              : 'Could not verify account.';
      }
    }
    if (e is FirebaseException) {
      if (e.code == 'permission-denied') {
        return 'Could not delete all data. Check your connection or Firestore rules.';
      }
      return e.message?.isNotEmpty == true
          ? e.message!
          : 'Something went wrong. Try again.';
    }
    if (e is StateError) {
      return e.message;
    }
    return 'Could not delete account. Try again later.';
  }
}

/// Shows password confirmation, runs deletion, then navigates to [LoginPage] on success.
Future<void> promptDeleteAccount(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _DeleteAccountDialog(title: title, message: message),
  );
  if (ok == true && context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final String title;
  final String message;

  const _DeleteAccountDialog({
    required this.title,
    required this.message,
  });

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordCtrl.text;
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your current password to confirm.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await AccountDeletionService.deleteAccountWithPassword(password);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AccountDeletionService.messageForError(e)),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message),
            const SizedBox(height: 8),
            Text(
              'Enter your account password to confirm.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordCtrl,
              obscureText: _obscure,
              enabled: !_loading,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Current password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _loading
                      ? null
                      : () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Delete permanently',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
