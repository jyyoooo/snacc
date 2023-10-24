import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Category> categorieslist = [];

  @override
  void initState() {
    super.initState();
    final categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;
  }

  String? selectedImgUrl;

  final catgoryNameCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // File? image;

  Future pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImgUrl = pickedImage.path;
      });
    } else {
      setState(() {
        selectedImgUrl ?? 'assets/images/no-image-available.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        leading: const Icon(
          Icons.transcribe,
          color: Colors.transparent,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // primary: true,
        title: const Text(
          'Welcome back, Admin',
          style: TextStyle(fontSize: 20, color: Colors.amber),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Catergories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),


              // ADD NEW CATEGORY
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const Text('Add a new Category',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: selectedImgUrl != null
                                                  ? Image.file(
                                                      File(selectedImgUrl!),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      color: Colors.grey,
                                                      child:
                                                          Image.asset('assets/images/no-image-available.png'),
                                                    )),
                                        ),
                                        SnaccButton(
                                            inputText: 'Pick Image',
                                            callBack: () {
                                              pickImage();
                                            }),
                                      ],
                                    ),const SizedBox(height: 10),
                                    TextFormField(
                                      controller: catgoryNameCtrl,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Category name',
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 10),
                                    SnaccButton(
                                      callBack: () {
                                        if (_formKey.currentState!.validate()) {
                                          final name = catgoryNameCtrl.text.trim();

                                          // ADD NEW CATEGORY
                                          addbtn(name,selectedImgUrl);

                                          selectedImgUrl = null;
                                          catgoryNameCtrl.clear();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const AlertDialog(
                                                    title: Text(
                                                        'Fields are empty'),
                                                  ));
                                        }
                                      },
                                      inputText: 'Add New Category',
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: categoryListNotifier,
                  builder: (BuildContext context, List<Category> categorylist,
                          Widget? child) =>
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: categorylist.length,
                              itemBuilder: (context, index) {
                                final category = categorylist[index];

                                return GestureDetector(
                                  onTap: () {
                                    print('tap id is ${category.categoryID}');
                                    Navigator.of(context)
                                        .push((MaterialPageRoute(
                                      builder: (context) => ListProducts(
                                        categoryName: category.categoryName,
                                        id: category.categoryID,
                                      ),
                                    )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.transparent,
                                              child: Image.file(
                                                  File(category.imageUrl!)),
                                            )),
                                        const SizedBox(height: 5),
                                        Text(
                                          category.categoryName!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text('Offers Section',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          //     IconButton(
          //         onPressed: () {},
          //         icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
          //   ],
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // Card(
          //   child: Image.asset('assets/images/Admin_page/ad_items.png'),
          // ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Combos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/popularcombo');
                  },
                  icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
            ],
          ),


          
          Expanded(
            child: FutureBuilder(
              future: getcomboListFromHive(),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){


                  final testCombos = snapshot.data;
                  if(testCombos != null){
                    return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  itemCount: testCombos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    
                    final testList = testCombos[index];

                    return SizedBox(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Expanded(
                                child: Image.file(
                                  File(testList.comboImgUrl??'assets/images/no-image-available.png'),
                                  height: 100,
                                ),
                              ),
                              const SizedBox(height: 10),
                               Text(
                                testList.comboName??'not available',
                                style:const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 5),
                               Text(
                                "${testList.comboPrice}",
                                style:const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );});
                  }else{
                    return const Text("no data");
                  }
                }else{
                  return const  CircularProgressIndicator();
                }
              }
              
            ),
          )
        ]),
      ),
    );
  }

  
}
