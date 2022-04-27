// import 'package:flutter/material.dart';
//
// import '../../services/my_controller.dart';
// import '../../utils/string_validator.dart';
// import '../home_page.dart';
//
// class SignInAccountPage extends StatefulWidget {
//   const SignInAccountPage({Key? key}) : super(key: key);
//
//   @override
//   _SignInAccountPageState createState() => _SignInAccountPageState();
// }
//
// class _SignInAccountPageState extends State<SignInAccountPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _emailController = TextEditingController();
//   final _pwController = TextEditingController();
//
//   String _errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_errorMessage, style: const TextStyle(color: Colors.red)),
//             TextFormField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               validator: (input) {
//                 if (validateNonEmptyMessage(input) != null) {
//                   return validateNonEmptyMessage(input);
//                 }
//                 if (validateEmailAddress(input) != null) {
//                   return validateEmailAddress(input);
//                 }
//                 validateEmailAddress(input);
//                 return null;
//               },
//               decoration: const InputDecoration(hintText: "Email Address"),
//             ),
//             TextFormField(
//               controller: _pwController,
//               obscureText: true,
//               validator: (input) {
//                 if (validateNonEmptyMessage(input) != null) {
//                   return validateNonEmptyMessage(input);
//                 }
//                 if (validatePassword(input) != null) {
//                   return validatePassword(input);
//                 }
//                 return null;
//               },
//               decoration: const InputDecoration(hintText: "Password"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   final String? errorCode = await MyController.signIn(
//                       email: _emailController.text,
//                       password: _pwController.text);
//
//                   if (errorCode == null) {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (_) => HomePage()),
//                       (_) => false,
//                     );
//                   } else {
//                     setState(() {
//                       _errorMessage = errorCode;
//                     });
//                   }
//                 }
//               },
//               child: const Text('Log In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _pwController.dispose();
//     super.dispose();
//   }
// }
