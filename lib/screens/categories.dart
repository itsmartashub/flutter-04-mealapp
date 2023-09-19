import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // u flutteru, kada kreiramo multi-screen app, da svaki screen koristi Scaffold widget jer je mozda AppBar drugaciji od screen-a do screen-a, drugaciji screen mzd ima drugaciji title ili btns u appbar
    return Scaffold(
        appBar: AppBar(title: const Text('Pick ur categories')),
        // body ja main page content
        body: GridView(
          // da kazemo koliko kolona treba da bude. crossAxisCount je s leva u desno, dakle horizontalno imam dve kolone. childAspectRatio sto se odnosi na velicinu grid itema
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2, // isto sto i 1.5 ???
            crossAxisSpacing: 20, // horizontalni razmak izmedju itema
            mainAxisSpacing: 20, // vertikalni razmak izmedju itema
          ),
          children: const [
            Text('1', style: TextStyle(color: Colors.white)),
            Text('2', style: TextStyle(color: Colors.white)),
            Text('3', style: TextStyle(color: Colors.white)),
            Text('4', style: TextStyle(color: Colors.white)),
            Text('5', style: TextStyle(color: Colors.white)),
            Text('6', style: TextStyle(color: Colors.white)),
          ],
        ));
  }
}
