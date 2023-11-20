import 'package:hive_flutter/hive_flutter.dart';
import '../DataModels/category_model.dart';
import '../DataModels/combo_model.dart';
import '../DataModels/product_model.dart';

Future<void> populateInitialData() async {
  // Open boxes
  final categoryBox = await Hive.openBox<Category>('category');
  final productBox = await Hive.openBox<Product>('products');
  final comboBox = await Hive.openBox<ComboModel>('combos');
  final carouselBox = await Hive.openBox<String>('carousel');

  // Check if data is already populated
  if (categoryBox.isEmpty &&
      productBox.isEmpty &&
      comboBox.isEmpty &&
      carouselBox.isEmpty) {

    // Dummy data for Category
    final popcorn = Category(
        categoryID: 0,
        categoryName: 'Popcorn',
        imageUrl: 'assets/images/Category_items/popcorn.png',
        productsReference: [0,1,2,3]);
    final juice = Category(
        categoryID: 1,
        categoryName: 'Juice',
        imageUrl: 'assets/images/Category_items/juice.png',
        productsReference: [4,5,6,7]);
    final sandwich = Category(
        categoryID: 2,
        categoryName: 'Sandwich',
        imageUrl: 'assets/images/Category_items/ssandwich.png',
        productsReference: [8,9,10,11]);
    final soda = Category(
        categoryID: 3,
        categoryName: 'Soda',
        imageUrl: 'assets/images/Category_items/soda.png',
        productsReference: [12,13,14,15,16]);
    final caffiene = Category(
        categoryID: 4,
        categoryName: 'Caffiene',
        imageUrl: 'assets/images/Category_items/caffiene.png',
        productsReference: []);
    final burger = Category(
        categoryID: 5,
        categoryName: 'Burger',
        imageUrl: 'assets/images/Category_items/burger.png',
        productsReference: [17,18,19,20]);

    // Save categories to the box
    await categoryBox.add(popcorn);
    await categoryBox.add(juice);
    await categoryBox.add(sandwich);
    await categoryBox.add(soda);
    await categoryBox.add(caffiene);
    await categoryBox.add(burger);

//***   PRODUCTS   ***//

// POPCORN

    final cheesepop = Product(
      productID: 0,
      prodimgUrl: 'assets/popcorns/cheesepop.png',
      prodname: 'Cheese Pop',
      prodprice: 50.0,
      description:
          'Savor the irresistible crunch of Cheese Popcorn—a delightful blend of crispy goodness and rich cheddar flavor. Perfect for any occasion, this snack promises a brief but satisfying burst of cheesy bliss.',
      categoryID: 0,
    );
    final chocopop = Product(
      productID: 1,
      prodimgUrl: 'assets/popcorns/chocopop.png',
      prodname: 'Choco Pop',
      prodprice: 50.0,
      description:
          'Savor the irresistible crunch of Choco Popcorn—a delightful blend of crispy goodness and rich choco flavor. Perfect for any occasion, this snack promises a brief but satisfying burst of choco bliss.',
      categoryID: 0,
    );
    final onionpop = Product(
      productID: 2,
      prodimgUrl: 'assets/popcorns/onionpop.png',
      prodname: 'Chinese Pop',
      prodprice: 50.0,
      description:
          'Savor the irresistible crunch of Chinese Popcorn—a delightful blend of crispy goodness and rich choco flavor. Perfect for any occasion, this snack promises a brief but satisfying burst of choco bliss.',
      categoryID: 0,
    );
    final sourpop = Product(
      productID: 3,
      prodimgUrl: 'assets/popcorns/sourpop.png',
      prodname: 'Sour Pop',
      prodprice: 50.0,
      description:
          'Savor the irresistible crunch of Sour Popcorn—a delightful blend of crispy goodness and sour flavor. Perfect for any occasion, this snack promises a brief but satisfying burst of choco bliss.',
      categoryID: 0,
    );

    await productBox.add(cheesepop);
    await productBox.add(chocopop);
    await productBox.add(onionpop);
    await productBox.add(sourpop);

    // JUICE

    final pineapple = Product(
      productID: 4,
      prodimgUrl: 'assets/juices/pineapple.png',
      prodname: 'Piineapple Juice',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing assortment of Juices. Bursting with natural flavors, these vibrant beverages offer a brief yet invigorating taste experience—a perfect choice for a quick, delightful sip.',
      categoryID: 1,
    );
    final avocado = Product(
      productID: 5,
      prodimgUrl: 'assets/juices/avocado.png',
      prodname: 'Avocado Juice',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing assortment of Juices. Bursting with natural flavors, these vibrant beverages offer a brief yet invigorating taste experience—a perfect choice for a quick, delightful sip.',
      categoryID: 1,
    );
    final cherry = Product(
      productID: 6,
      prodimgUrl: 'assets/juices/cherry.png',
      prodname: 'Cherry Juice',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing assortment of Juices. Bursting with natural flavors, these vibrant beverages offer a brief yet invigorating taste experience—a perfect choice for a quick, delightful sip.',
      categoryID: 1,
    );
    final strawberry = Product(
      productID: 7,
      prodimgUrl: 'assets/juices/strawberry.png',
      prodname: 'Strawberry Juice',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing assortment of Juices. Bursting with natural flavors, these vibrant beverages offer a brief yet invigorating taste experience—a perfect choice for a quick, delightful sip.',
      categoryID: 1,
    );

    await productBox.add(pineapple);
    await productBox.add(avocado);
    await productBox.add(cherry);
    await productBox.add(strawberry);

//  SANDWICH
    final baconMix = Product(
      productID: 8,
      prodimgUrl: 'assets/sanwiches/bacon mix.png',
      prodname: 'Bacon Mix',
      prodprice: 40.0,
      description:
          'Savor the satisfaction of our delectable sandwiches. Crafted with premium ingredients, these handheld delights promise a quick, flavorful bite that effortlessly elevates your snack time. Bite into a world of taste with our sumptuous sandwich offerings.',
      categoryID: 2,
    );
    final cheesewich = Product(
      productID: 9,
      prodimgUrl: 'assets/sanwiches/cheesewich.png',
      prodname: 'Cheesewich',
      prodprice: 40.0,
      description:
          'Savor the satisfaction of our delectable sandwiches. Crafted with premium ingredients, these handheld delights promise a quick, flavorful bite that effortlessly elevates your snack time. Bite into a world of taste with our sumptuous sandwich offerings.',
      categoryID: 2,
    );
    final doubleBacon = Product(
      productID: 10,
      prodimgUrl: 'assets/sanwiches/doublebacon.png',
      prodname: 'Double Bacon',
      prodprice: 40.0,
      description:
          'Savor the satisfaction of our delectable sandwiches. Crafted with premium ingredients, these handheld delights promise a quick, flavorful bite that effortlessly elevates your snack time. Bite into a world of taste with our sumptuous sandwich offerings.',
      categoryID: 2,
    );
    final veggiewich = Product(
      productID: 11,
      prodimgUrl: 'assets/sanwiches/veggiewich.png',
      prodname: 'Veggiewich',
      prodprice: 40.0,
      description:
          'Savor the satisfaction of our delectable sandwiches. Crafted with premium ingredients, these handheld delights promise a quick, flavorful bite that effortlessly elevates your snack time. Bite into a world of taste with our sumptuous sandwich offerings.',
      categoryID: 2,
    );

    await productBox.add(baconMix);
    await productBox.add(cheesewich);
    await productBox.add(doubleBacon);
    await productBox.add(veggiewich);

    // SODA

    final sevenUp = Product(
      productID: 12,
      prodimgUrl: 'assets/sodas/7up.png',
      prodname: '7 Up classic',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing sodas. Fizzing with effervescence and bursting with flavor, our sodas are the perfect companion to any moment. Immerse yourself in the crisp and delightful experience, sip by sip, as you indulge in the effervescent joy of our soda selection.',
      categoryID: 3,
    );
    final cokeZero = Product(
      productID: 13,
      prodimgUrl: 'assets/sodas/cokezero.png',
      prodname: 'Coke Zero',
      prodprice: 45.0,
      description:
          'Quench your thirst with our refreshing sodas. Fizzing with effervescence and bursting with flavor, our sodas are the perfect companion to any moment. Immerse yourself in the crisp and delightful experience, sip by sip, as you indulge in the effervescent joy of our soda selection.',
      categoryID: 3,
    );
    final dietCoke = Product(
      productID: 14,
      prodimgUrl: 'assets/sodas/dietcoke.png',
      prodname: 'Diet Coke',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing sodas. Fizzing with effervescence and bursting with flavor, our sodas are the perfect companion to any moment. Immerse yourself in the crisp and delightful experience, sip by sip, as you indulge in the effervescent joy of our soda selection.',
      categoryID: 3,
    );

    final ogCoke = Product(
      productID: 15,
      prodimgUrl: 'assets/sodas/ogcoke.png',
      prodname: 'Coca Cola ',
      prodprice: 60.0,
      description:
          'Quench your thirst with our refreshing sodas. Fizzing with effervescence and bursting with flavor, our sodas are the perfect companion to any moment. Immerse yourself in the crisp and delightful experience, sip by sip, as you indulge in the effervescent joy of our soda selection.',
      categoryID: 3,
    );
    final pxpsi = Product(
      productID: 16,
      prodimgUrl: 'assets/sodas/pepsi.png',
      prodname: 'Coca Cola ',
      prodprice: 40.0,
      description:
          'Quench your thirst with our refreshing sodas. Fizzing with effervescence and bursting with flavor, our sodas are the perfect companion to any moment. Immerse yourself in the crisp and delightful experience, sip by sip, as you indulge in the effervescent joy of our soda selection.',
      categoryID: 3,
    );

    await productBox.add(sevenUp);
    await productBox.add(cokeZero);
    await productBox.add(dietCoke);
    await productBox.add(ogCoke);
    await productBox.add(pxpsi);

    // BURGER
    final bigFatty = Product(
      productID: 17,
      prodimgUrl: 'assets/burgers/big_fatty_burger.png',
      prodname: 'Coca Cola ',
      prodprice: 180.0,
      description:
          'Savor the mouthwatering delight of our burgers. Crafted with the finest ingredients, each bite is a symphony of flavors that will tantalize your taste buds. Whether you crave a classic or desire something bold and adventurous, our burgers are the epitome of culinary satisfaction. Experience the perfect blend of juicy goodness and savory perfection in every delicious bite.',
      categoryID: 3,
    );
    final cheeseHamOnion = Product(
      productID: 18,
      prodimgUrl: 'assets/burgers/cheese_ham_onion.png',
      prodname: 'Cheese Burger ',
      prodprice: 120.0,
      description:
          'Savor the mouthwatering delight of our burgers. Crafted with the finest ingredients, each bite is a symphony of flavors that will tantalize your taste buds. Whether you crave a classic or desire something bold and adventurous, our burgers are the epitome of culinary satisfaction. Experience the perfect blend of juicy goodness and savory perfection in every delicious bite.',
      categoryID: 3,
    );
    final loadedVegBurger = Product(
      productID: 19,
      prodimgUrl: 'assets/burgers/loade_veg_burger.png',
      prodname: 'Loaded Burger ',
      prodprice: 120.0,
      description:
          'Savor the mouthwatering delight of our burgers. Crafted with the finest ingredients, each bite is a symphony of flavors that will tantalize your taste buds. Whether you crave a classic or desire something bold and adventurous, our burgers are the epitome of culinary satisfaction. Experience the perfect blend of juicy goodness and savory perfection in every delicious bite.',
      categoryID: 3,
    );
    final mushroomBurger = Product(
      productID: 20,
      prodimgUrl: 'assets/burgers/mushroom_burger.png',
      prodname: 'Mushroom Burger ',
      prodprice: 120.0,
      description:
          'Savor the mouthwatering delight of our burgers. Crafted with the finest ingredients, each bite is a symphony of flavors that will tantalize your taste buds. Whether you crave a classic or desire something bold and adventurous, our burgers are the epitome of culinary satisfaction. Experience the perfect blend of juicy goodness and savory perfection in every delicious bite.',
      categoryID: 3,
    );

    await productBox.add(bigFatty);
    await productBox.add(cheeseHamOnion);
    await productBox.add(loadedVegBurger);
    await productBox.add(mushroomBurger);

    // COMBOMODEL

    final cheesePopAndPxpsiCombo = ComboModel(
      comboID: 0,
      comboName: '${cheesewich.prodname} & ${pxpsi.prodname}',
      comboPrice: 90.0,
      comboImgUrl: 'assets/popular_combos/sandwich cola.png',
      comboItems: [cheesewich, pxpsi],
      isFavorite: false,
      description:
          'Savor the perfect pairing of our Sandwich & Soda Combo. Delicious sandwiches meet fizzy refreshment for a delightful treat. A quick and satisfying combo for your cravings',
    );
    final popcornAndSodaCombo = ComboModel(
      comboID: 1,
      comboName: '${chocopop.prodname} & ${dietCoke.prodname}',
      comboPrice: 90.0,
      comboImgUrl: 'assets/popular_combos/Popcorn and cola.png',
      comboItems: [chocopop, dietCoke],
      isFavorite: false,
      description:
          'Savor the perfect pairing of our Sandwich & Soda Combo. Delicious sandwiches meet fizzy refreshment for a delightful treat. A quick and satisfying combo for your cravings',
    );
    final burgerAndSodaCombo = ComboModel(
      comboID: 2,
      comboName: '${bigFatty.prodname} & ${ogCoke.prodname}',
      comboPrice: 90.0,
      comboImgUrl: 'assets/popular_combos/burgir cola.png',
      comboItems: [bigFatty, ogCoke],
      isFavorite: false,
      description:
          'Perfect pairing of our BigFatty & Soda Combo. Delicious sandwiches meet fizzy refreshment for a delightful treat. A quick and satisfying combo for your cravings',
    );
    final sandwichAndSodaCombo = ComboModel(
      comboID: 3,
      comboName: '${baconMix.prodname} & ${cokeZero.prodname}',
      comboPrice: 90.0,
      comboImgUrl: 'assets/popular_combos/sandwich cola.png',
      comboItems: [baconMix, cokeZero],
      isFavorite: false,
      description:
          'Savor the perfect pairing of our BaconMix & Zero-Soda Combo. Delicious sandwiches meet fizzy refreshment for a delightful treat. A quick and satisfying combo for your cravings',
    );

    // Save combos to the box
    await comboBox.add(cheesePopAndPxpsiCombo);
    await comboBox.add(popcornAndSodaCombo);
    await comboBox.add(burgerAndSodaCombo);
    await comboBox.add(sandwichAndSodaCombo);

    // Dummy data for carousel
    var carouselItem1 = 'assets/images/Admin_page/halloween_ad.jpg';
    var carouselItem2 = 'assets/images/Admin_page/offer1.jpeg';
    var carouselItem3 = 'assets/images/Admin_page/pocorn_soda_ad.png';

    // Save carousel items to the box
    await carouselBox.addAll([carouselItem1, carouselItem2, carouselItem3]);
  }
}
