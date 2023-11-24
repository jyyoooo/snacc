// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:snacc/Widgets/snacc_textfield.dart';

// import '../../DataModels/user_model.dart';

// class EditProfile extends StatelessWidget {
//   UserModel user;
//   EditProfile({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final newNameController = TextEditingController(text: user.username);
//     final newUserNameController = TextEditingController(text: user.userMail);
//     // final oldPasswordController = TextEditingController();
//     // final newPasswordController = TextEditingController();
//     // final confrimPasswordController = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Edit Profile',
//           style:
//               GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 23),
//         ),
//       ),
//       backgroundColor: Colors.grey[100],
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             SnaccTextField(
//               label: 'Enter New Name',
//               controller: newNameController,
//             ),
//             const Gap(10),
//             SnaccTextField(
//               label: 'Enter Username',
//               controller: newUserNameController,
//             ),
//             const Gap(10),
//             // SnaccTextField(
//             //   label: 'Enter Old Password',
//             //   controller: oldPasswordController,
//             // ),
//             // const Gap(10),
//             // SnaccTextField(
//             //   label: 'Enter New Password',
//             //   controller: oldPasswordController,
//             // ),
//             // const Gap(10),
//             // SnaccTextField(
//             //   label: 'Confirm New Password',
//             //   controller: confrimPasswordController,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
