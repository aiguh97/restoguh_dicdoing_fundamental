// import 'package:flutter/material.dart';

// class ReviewForm extends StatelessWidget {
//   final TextEditingController nameCtl;
//   final TextEditingController reviewCtl;
//   final VoidCallback onSubmit;
//   const ReviewForm({
//     super.key,
//     required this.nameCtl,
//     required this.reviewCtl,
//     required this.onSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Tulis Ulasan',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: nameCtl,
//           decoration: const InputDecoration(labelText: 'Nama'),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: reviewCtl,
//           decoration: const InputDecoration(labelText: 'Ulasan'),
//           maxLines: 3,
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: onSubmit,
//                 child: const Text('Kirim Ulasan'),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
