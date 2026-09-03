import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotina_comercial/auth/auth_provider.dart';
import 'package:rotina_comercial/theme.dart';
import 'package:rotina_comercial/utils/toast.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tokenName = auth.token != null ? _extractName(auth.token!) : '';
    final userName = tokenName.isNotEmpty
        ? tokenName
        : (auth.userName.isNotEmpty ? auth.userName : 'Usuário');
    final email = auth.token != null ? _extractEmail(auth.token!) : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset('assets/ic_user.png', width: 60, height: 60),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'Open Sans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (email.isNotEmpty)
              Text(
                email,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  fontFamily: 'Open Sans',
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                label: const Text(
                  'SAIR DA CONTA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Open Sans',
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: const Text(
                        'Sair da conta',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                      content: const Text(
                        'Deseja realmente sair da sua conta?',
                        style: TextStyle(fontFamily: 'Open Sans'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancelar',
                              style: TextStyle(fontFamily: 'Open Sans')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    showToast('Deslogado com sucesso!');
                    await context.read<AuthProvider>().logout();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Map<String, dynamic>? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      final decoded = utf8.decode(base64.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String _extractName(String token) {
    final map = _decodeToken(token);
    if (map == null) return '';
    final user = map['user'];
    if (user != null && user is Map) {
      return user['nome'] ?? '';
    }
    return '';
  }

  static String _extractEmail(String token) {
    final map = _decodeToken(token);
    if (map == null) return '';
    final user = map['user'];
    if (user != null && user is Map) {
      return user['email'] ?? '';
    }
    return '';
  }
}
