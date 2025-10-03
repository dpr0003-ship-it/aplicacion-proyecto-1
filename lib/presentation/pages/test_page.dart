import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class TestPage extends StatefulWidget {
  final String testId;
  const TestPage({super.key, required this.testId});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // Guarda la opción seleccionada por pregunta
  final Map<int, int> _selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TestProvider>(context);
    final test = provider.test;

    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('❌ ${provider.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadTest(widget.testId),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : test == null
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () => provider.loadTest(widget.testId),
                          child: const Text('Cargar Test'),
                        ),
                      )
                    : (test.preguntas == null || test.preguntas.isEmpty)
                        ? const Center(child: Text('No hay preguntas disponibles.'))
                        : ListView.builder(
                            itemCount: test.preguntas.length,
                            itemBuilder: (_, i) {
                              final p = test.preguntas[i];
                              final opciones = p.opciones ?? [];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pregunta ${i + 1}: ${p.pregunta ?? "Sin texto"}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      ...opciones.asMap().entries.map((e) => RadioListTile<int>(
                                            value: e.key,
                                            groupValue: _selectedOptions[i],
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedOptions[i] = val!;
                                              });
                                            },
                                            title: Text(e.value ?? ""),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
      ),
    );
  }
}