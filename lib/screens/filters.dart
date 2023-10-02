import 'package:flutter/material.dart';

// import 'package:meal_app/screens/tabs.dart';
// import 'package:meal_app/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
        // pravimo Column jer zelimo da prikazemo multiple filter sviceve za filter on-off
      ),
      /*  // s ovim ce back button na ovom FiltersScreen-u da nestane, i bice zamenjen sa drawer button gde kad kliknemo pojavi se side drawer
      drawer: MainDrawer(onSelectScreen: (identifier) {
        Navigator.of(context).pop();

        if (identifier == 'meals') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => const TabsScreen(),
          ));
        }
      }), */
      body: Column(
        children: [
          /*
        ? SwitchListTile - radio btn u CSS
        value je boolean: true (on) ili false (off)
        onChanged je fn koja prihvata boolean, i ona ce se trigerovati kada god se switch pritisne
        title je nesto poput labela */
          SwitchListTile(
            value: _glutenFreeFilterSet,
            onChanged: (isChecked) {
              // posto apdejtujemo UI kor setState
              setState(() {
                _glutenFreeFilterSet = isChecked;
              });
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Only include gluten-free meals.',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
        ],
      ),
    );
  }
}
