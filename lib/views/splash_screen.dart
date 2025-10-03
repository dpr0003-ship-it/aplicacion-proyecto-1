import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../routing/app_routes.dart';
import '../core/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.watch<AuthProvider>();
    if (!auth.loading) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(
          context, auth.user == null ? AppRoutes.login : AppRoutes.home,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: LoadingIndicator(text:'Cargando...'));
}
