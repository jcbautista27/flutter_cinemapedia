import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  Stream<String> getLoadingMessages() {

    final messages = <String>[
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Ya casi',
      'Ya mero...',
      'Esto está tardando más de lo esperado :('
    ];

    return Stream.periodic(const Duration(milliseconds: 1200),(step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Espere, cargando...'),
            const SizedBox(height: 10,),
            const CircularProgressIndicator(),
            const SizedBox(height: 10,),
            StreamBuilder(
              stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return const Text('Cargando...');
                return Text(snapshot.data!);
              },
            )

          ],
        )
      ),
    );
  }
}