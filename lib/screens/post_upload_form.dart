// import 'package:flutter/material.dart';

// class PostUploadForm extends StatefulWidget {
//   const PostUploadForm({Key? key, required this.onSubmit}) : super(key: key);

//   final Function({
//     required String caption,
//     required String description,
//     required String imageUrl,
//     required DateTime timestamp,
//   }) onSubmit;

//   @override
//   _PostUploadFormState createState() => _PostUploadFormState();
// }

// class _PostUploadFormState extends State<PostUploadForm> {
//   final TextEditingController _captionController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   String? _imageUrl;
//   bool _isUploading = false;

//   // Future<void> _submit() async {
//   //   if (_imageUrl == null) return;
//   //   if (_isUploading) return;

//   //   setState(() {
//   //     _isUploading = true;
//   //   });

//   //   final timestamp = DateTime.now();

//   //   try {
//   //     await widget.onSubmit(
//   //       caption: _captionController.text.trim(),
//   //       description: _descriptionController.text.trim(),
//   //       imageUrl: _imageUrl!,
//   //       timestamp: timestamp,
//   //     );

//   //     Navigator.pop(context);
//   //   } catch (error) {
//   //     setState(() {
//   //       _isUploading = false;
//   //     });

//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text('Failed to upload post. Please try again later.'),
//   //       ),
//   //     );
//   //   }
//   // }

//  Future<void> _uploadPost() async {
//     if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image')),
//       );
//       return;
//     }

//     if (_captionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a caption')),
//       );
//       return;
//     }

//     if (_descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a description')),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     final StorageReference storageReference =
//         FirebaseStorage.instance.ref().child('posts/${DateTime.now()}');
//     final StorageUploadTask uploadTask = storageReference.putFile(_imageFile!);
//     final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
//     final String url = (await downloadUrl.ref.getDownloadURL());

//     await FirebaseFirestore.instance.collection('posts').add({
//       'imageUrl': url,
//       'caption': _captionController.text,
//       'description': _descriptionController.text,
//       'createdAt': DateTime.now(),
//     });

//     setState(() {
//       _isUploading = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Post uploaded successfully')),
//     );

//     _clear();
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Post'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             if (_imageUrl != null)
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: Image.network(
//                   _imageUrl!,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _captionController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter a caption',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLength: 100,
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: null,
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 // TODO: Implement image picker
//               },
//               child: const Text('Select an Image'),
//             ),
//             const SizedBox(height: 20),
//             if (_isUploading) const CircularProgressIndicator(),
//             if (!_isUploading && _imageUrl != null)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.green,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                   ),
//                   onPressed: _uploadPost,
//                   child: const Text('Upload'),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
