import 'package:flutter/material.dart';

import '../views/splash_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home/home_screen.dart';
import '../views/home/add_edit_videojuego_screen.dart';
import '../views/home/videojuego_detail_screen.dart';
import '../core/models/videojuego_model.dart'; // <- ruta correcta


class AppRoutes {
  static const initial  = '/';
  static const login    = '/login';
  static const register = '/register';
  static const home     = '/home';
  static const addEdit  = '/addEdit';
  static const detail   = '/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addEdit:
        final initial = settings.arguments as Videojuego?;
        return MaterialPageRoute(
          builder: (_) => AddEditVideojuegoScreen(initial: initial),
        );
      case detail:
        final game = settings.arguments as Videojuego;
        return MaterialPageRoute(
          builder: (_) => VideojuegoDetailScreen(game: game),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
