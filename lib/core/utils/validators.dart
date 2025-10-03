class Validators {
  static String? requiredField(String? v, {String name = 'Campo'}) {
    if (v == null || v.trim().isEmpty) return '$name es obligatorio';
    return null;
  }

  static String? positiveInt(String? v, {String name = 'Valor'}) {
    final n = int.tryParse(v ?? '');
    if (n == null || n < 0) return '$name debe ser entero ≥ 0';
    return null;
  }

  static String? positiveDouble(String? v, {String name = 'Valor'}) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
    if (n == null || n < 0) return '$name debe ser número ≥ 0';
    return null;
  }
}
