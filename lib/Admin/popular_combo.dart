import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/Admin/Widgets/combo_list.dart';
import 'package:snacc/Admin/Widgets/product_image_row.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';

class PopularCombo extends StatefulWidget {
  const PopularCombo({super.key});
  

  @override
  State<PopularCombo> createState() => _PopularComboState();
}

class _PopularComboState extends State<PopularCombo> {
  Product? selectedProduct;
  Product? productOne;
  Product? productTwo;
  String? pickedImage;
  double? comboPrice;
  String? comboName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // APPBAR //
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SnaccAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Create Combo'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              
              // CHOOSE PRODUCT //
              ComboItemList(onProductSelected: handleSelectedProduct),
              SnaccButton(
                width: 70,
                btncolor: Colors.amber,
                textColor: Colors.white,
                inputText: 'ADD',
                callBack: ()async {
              if (selectedProduct != null) {
                updateImages();
                setState(() {});
              } else {
                // ignore: avoid_print
                print('no product selected');
              }
              comboPrice = await getComboPrice(productOne,productTwo);
              comboName = await getComboName(productOne, productTwo);
                },
              ),
              
              const SizedBox(height: 10),

              // SHOW SELECTED PRODUCT IMAGE //
              ProductImageRow( 
                productOne: productOne,
                productTwo: productTwo,
              ),
              const SizedBox(height: 15,),

              // SHOW COMBO PRICE
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(color: Colors.grey[300],
                 height: 40,width: double.infinity,
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                   Text(' ${ comboName ??= 'Combo '}',
                   style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                   Text('₹ ${ comboPrice ??= 0.00}',
                   style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)],),
                 )),
              ),
              const SizedBox(height: 20,),

              // PICK COMBO IMAGE //
              const Text('Select combo image',style: TextStyle(fontSize: 17),),
              const SizedBox(height: 10),

              // SHOW COMBO IMAGE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 100,width: 100,child:
                  pickedImage != null?
                   Image.file(File(pickedImage!)): const Center(
                    child: Text('No Image selected',textAlign: TextAlign.center,
                    
                    style: TextStyle(color: Colors.grey),)),),
                   SnaccButton(icon:  const Icon(Icons.photo,color: Colors.blue,) ,inputText: '', 
                   callBack: () async{
                    final String pickedImagePath = await pickImageFromGallery();
                    // print('pickedImagePath $pickedImagePath');
                    setState(() {
                      pickedImage = pickedImagePath;
                      // print('pickedImg = $pickedImage');
                    });
                                    
                    // addProductsToComboList(productOne, productTwo, pickedImagePath);
                  },width: 60,btncolor: Colors.white70,),
                ],
              ),
              
              // ADD COMBO TO HIVE
              SnaccButton(inputText: 'CREATE COMBO', 
              callBack: (){createCombo(productOne, productTwo,pickedImage);  })
            ],
          ),
        ),
      ),
    );
  }
  void handleSelectedProduct(Product? product) {
    setState(() {
      selectedProduct = product;
    });
  }

  void updateImages() {
    if (productOne == null) {
      productOne = selectedProduct;
      setState(() {
        productOne = selectedProduct;
      });
    } else if (productTwo == null) {
      productTwo = selectedProduct;
    } else {
      //ignore: avoid_print
      print('products already assigned');
    }
  }
}
