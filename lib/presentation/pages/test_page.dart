import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class TestPage extends StatelessWidget {
  final String testId;
  const TestPage({super.key, required this.testId});

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
                ? Center(child: Text('❌ ${provider.error}'))
                : test == null
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () => provider.loadTest(testId),
                          child: const Text('Cargar Test'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: test.preguntas.length,
                        itemBuilder: (_, i) {
                          final p = test.preguntas[i];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pregunta ${i + 1}: ${p.pregunta}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  ...p.opciones.asMap().entries.map((e) => ListTile(
                                        leading: const Icon(Icons.circle_outlined),
                                        title: Text(e.value),
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