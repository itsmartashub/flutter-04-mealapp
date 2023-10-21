import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:transparent_image/transparent_image.dart'; // kTransparentImage
import 'package:meal_app/widgets/meal_item_trait.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  // da prvo slovo bude veliko. meal.complexity.name.substring(1); secemo sve od 2. karaktera, dakle prvo slovo ne
  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      // ovo mu dodje kao kad u css koristimo border-radius, pa ivice nisu zaoblicene, vec vire iz parenta, pa koristimo overflow: hidden; e za to i ovo clipBehavior: Clip.hardEdge sluzi
      clipBehavior: Clip.hardEdge,
      // elevation mu dodje card shadow
      elevation: 2,
      child: InkWell(
        // ne mozemo samo onTap: onSelectMeal jer treba da prosledimo meal. I sad gde god pozivamo ovaj MenuItem widget, dodajemmo za property i onSelectMeal
        onTap: () {
          onSelectMeal(meal);
        },
        /* Stack ovo je widget koji moze da se koristi da se pozicionira vise widgeta jedno iznad drugog (jedan preko drugog valjda), ali ne jedan iznad drugog poredjani u column, vec direktno jedan iznad drugog. Recimo slika da bude kao bg, a text na top of it  */
        child: Stack(
          children: [
            /* pocinjemo sa onim koji ce biti na bottom-u, takoreci background. Za to cemo staviti da bude FadeInImage koji je flutter utility widget koji govori da ce se tu placeovari slika koja ce fejdinovati, dakle kad se slika ucita da se smoothli prikaze, fading in, a ne da samo iskoci. Tu takodje treba da prikazemo placeholder koji ce se prikazati inicijalno. zaplaceholder cemo koristiti flutter package koji cemo instalirati transparent_image:
                ``` dart pub add transparent_image
            Da bismo to prikazali adekvatno tu cemo koristiti MemoryImage() flutter klasu koja zna kako da ucita slike iz memorije. A u MemoryImage prosledjujemo kTransparentImage koju importujemo iz transparent_image paketa.
            Slika ce biti NetworkImage, tj slika sa neta,a link sa to se nalazi u nasem dummy-data za Meal u imageUrl propertiju */
            /*  FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              // kao u css za image object-fit: cover
              fit: BoxFit.cover,
              height: 200,
              // width: double.infinity kao u css width: max-width; koliko god moze horizontalno da zauzme mesto
              width: double.infinity,
            ), */

            //@ SCREENS TRANSITIONS - #COMMINGFROM place
            /* ? Hero
            - Ovaj flutter widget sluzi da animira widgete izmedju razlicitih widgeta, izmedju razlicitih skrinova.
            Potreban mu je tag koji sluzi za identifikovanje widgeta na ovom skrinu i na target skrinu. Tag treba da bude unikatan za svaki widget.
            I sada treba da idemo na mesto gde zelimo da idemo (kaorecimo s jedne stranice idemo na drugu, pa je taj odlazak tj dolazak na drugu animirano, tako i ovde). Ovo je mesto "coming from", a sad idemo na mesto koje je "going to" a to je meals_details.dart skrin i pronalazimo widget kom zelimo da animiramo, a to je u ovom slucaju Image.network i njega wrapujemo u Hero() takodje */
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                // kao u css za image object-fit: cover
                fit: BoxFit.cover,
                height: 200,
                // width: double.infinity kao u css width: max-width; koliko god moze horizontalno da zauzme mesto
                width: double.infinity,
              ),
            ),

            /* ? Positioned Widget
            Iznad ovog widgeta ce se nalaziti container koji ce prikazivati ime obroka,i neke meta informacije o tom obroku. A za pozicioniranje widgeta iznad drugog widgeta unutar Stack-a, flutter nam daje jos jedan veoma koristan widget cije je ime Positioned widget. */
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      //  overflow: TextOverflow.ellipsis ▶️ Ako je text suvise dugacak isece ga i doda tri tacke
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // jao, postoji objasnjenje kako ovde mozemo Row u Row, nesto jer je ovo unutar Column, a Column unutar Container koji je unutar Positioned koji ima setovano left i right 0 (dakel fixed width koji prosledjujemo childu, pa taj svom childu i tako do row), te je valjda width 100% i jos neka cuda, npm
                    Row(
                      // center items horizontally when it comes to Row
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // label treba da je String, pa ga ili stavljamo u '' i koristimo ${} ili stavljanjem .toString() metoda
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration} min',
                        ),

                        const SizedBox(width: 12),

                        MealItemTrait(
                          icon: Icons.work,
                          // complexity je enum. btw, kada prisustvujemo samo nekoj varijabli kao complexityText, ne moramo ${} vec samo $
                          // label: '${meal.complexity} min',
                          label: complexityText,
                        ),
                        const SizedBox(width: 12),

                        MealItemTrait(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
