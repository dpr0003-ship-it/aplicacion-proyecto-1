import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/providers/auth_provider.dart';
import '../../routing/app_routes.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => Validators.requiredField(v, name: 'Email'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pass,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (v) => Validators.requiredField(v, name: 'Contraseña'),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Entrar',
              loading: _loading,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                setState(() => _loading = true);
                try {
                  await context.read<AuthProvider>().login(_email.text.trim(), _pass.text.trim());
                  if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                } finally { if (mounted) setState(() => _loading = false); }
              },
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
              child: const Text('Crear cuenta'),
            )
          ]),
        ),
      ),
    );
  }
}
