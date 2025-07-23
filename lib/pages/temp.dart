// import 'dart:async';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const VaultApp());
// }
//
// class VaultApp extends StatelessWidget {
//   const VaultApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Vault App',
//       theme: ThemeData(
//         primarySwatch: Colors.amber,
//         scaffoldBackgroundColor: const Color(0xFFF3F4F6),
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Color(0xFF1F2937)),
//         ),
//       ),
//       home: const VaultHomePage(),
//     );
//   }
// }
//
// class Document {
//   final int id;
//   final String name;
//   final String type;
//   final String category;
//   final String updatedTime;
//   final String size;
//   final String content;
//
//   Document({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.category,
//     required this.updatedTime,
//     required this.size,
//     required this.content,
//   });
// }
//
// class Category {
//   final String id;
//   final String name;
//   final IconData icon;
//   final Color color;
//
//   Category({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//   });
// }
//
// class VaultHomePage extends StatefulWidget {
//   const VaultHomePage({super.key});
//
//   @override
//   _VaultHomePageState createState() => _VaultHomePageState();
// }
//
// class _VaultHomePageState extends State<VaultHomePage> {
//   String currentScreen = 'home';
//   Document? selectedDocument;
//   List<Document> documents = [
//     Document(
//       id: 1,
//       name: 'Passport Copy',
//       type: 'pdf',
//       category: 'legal',
//       updatedTime: '3 weeks ago',
//       size: '2.4 MB',
//       content: 'This is a secure passport document copy...',
//     ),
//     Document(
//       id: 2,
//       name: 'Insurance Policy',
//       type: 'pdf',
//       category: 'medical',
//       updatedTime: '5 months ago',
//       size: '1.8 MB',
//       content: 'Insurance policy document with coverage details...',
//     ),
//     Document(
//       id: 3,
//       name: 'Diploma Certificate',
//       type: 'pdf',
//       category: 'legal',
//       updatedTime: '1 week ago',
//       size: '3.2 MB',
//       content: 'Official diploma certificate from university...',
//     ),
//     Document(
//       id: 4,
//       name: 'Medical Report',
//       type: 'pdf',
//       category: 'medical',
//       updatedTime: '1 week ago',
//       size: '1.5 MB',
//       content: 'Comprehensive medical report and test results...',
//     ),
//     Document(
//       id: 5,
//       name: 'Resume 2025',
//       type: 'doc',
//       category: 'legal',
//       updatedTime: '2 months ago',
//       size: '987 KB',
//       content: 'Professional resume with latest experience and skills...',
//     ),
//     Document(
//       id: 6,
//       name: 'Social Security Card',
//       type: 'pdf',
//       category: 'legal',
//       updatedTime: '1 month ago',
//       size: '756 KB',
//       content: 'Social security card document copy...',
//     ),
//   ];
//
//   bool uploadModal = false;
//   bool isUploading = false;
//   double uploadProgress = 0;
//   Map<String, String>? selectedFile;
//   String selectedCategory = 'all';
//   bool securityLocked = true;
//   String password = '';
//
//   final categories = [
//     Category(id: 'all', name: 'All Docs', icon: Icons.folder_open, color: const Color(0xFFFDE047)),
//     Category(id: 'bank', name: 'Bank', icon: Icons.account_balance, color: const Color(0xFF9CA3AF)),
//     Category(id: 'medical', name: 'Medical', icon: Icons.favorite, color: const Color(0xFFF87171)),
//     Category(id: 'legal', name: 'Legal', icon: Icons.account_balance_wallet, color: const Color(0xFF60A5FA)),
//   ];
//
//   List<Document> getDocumentsByCategory() {
//     if (selectedCategory == 'all') return documents;
//     return documents.where((doc) => doc.category == selectedCategory).toList();
//   }
//
//   IconData getFileIcon(String type) {
//     switch (type) {
//       case 'pdf':
//         return Icons.picture_as_pdf;
//       case 'doc':
//         return Icons.description;
//       case 'jpg':
//       case 'png':
//         return Icons.image;
//       default:
//         return Icons.insert_drive_file;
//     }
//   }
//
//   Color getCategoryColor(String category) {
//     final cat = categories.firstWhere((c) => c.id == category, orElse: () => categories[1]);
//     return cat.color;
//   }
//
//   void handleFileUpload() {
//     setState(() {
//       selectedFile = {'name': 'Document_Name.pdf', 'type': 'pdf', 'size': '2.1 MB'};
//       uploadModal = true;
//     });
//   }
//
//   void simulateUpload() {
//     setState(() {
//       isUploading = true;
//       uploadProgress = 0;
//     });
//
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       setState(() {
//         uploadProgress += (15 * (0.5 + 0.5)); // Simplified random simulation
//         if (uploadProgress >= 100) {
//           timer.cancel();
//           setState(() {
//             isUploading = false;
//             final newDoc = Document(
//               id: documents.length + 1,
//               name: selectedFile!['name']!.replaceAll('.pdf', ''),
//               type: selectedFile!['type']!,
//               category: 'legal',
//               updatedTime: 'just now',
//               size: selectedFile!['size']!,
//               content: 'This is a newly uploaded document...',
//             );
//             documents.insert(0, newDoc);
//             uploadModal = false;
//             selectedFile = null;
//             currentScreen = 'home';
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Document uploaded successfully!')),
//           );
//         }
//       });
//     });
//   }
//
//   void handleSecurityUnlock() {
//     if (password == '1234') {
//       setState(() {
//         securityLocked = false;
//         password = '';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Incorrect password')),
//       );
//       setState(() {
//         password = '';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     if (securityLocked) {
//       return Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFFBBF24),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.lock, size: 40, color: Color(0xFF1F2937)),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Vault Locked',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Enter your password to access documents',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF6B7280),
//                       // textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Enter password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                     ),
//                     obscureText: true,
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) => password = value,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: handleSecurityUnlock,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFBBF24),
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Unlock Vault',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Demo password: 1234',
//                     style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (uploadModal) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
//             onPressed: () => setState(() => uploadModal = false),
//           ),
//           title: const Text('Vault', style: TextStyle(fontWeight: FontWeight.bold)),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.person, color: Color(0xFF1F2937)),
//               onPressed: () {},
//             ),
//           ],
//           backgroundColor: Colors.white,
//           elevation: 1,
//         ),
//         body: SafeArea(
//           child: isUploading
//               ? Center(
//             child: Container(
//               padding: const EdgeInsets.all(40),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     offset: Offset(0, 2),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Uploading',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Uploading "${selectedFile?['name']}" ${uploadProgress.round()}%',
//                     style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
//                   ),
//                   const SizedBox(height: 30),
//                   LinearProgressIndicator(
//                     value: uploadProgress / 100,
//                     backgroundColor: const  Color(0xFFE5E7EB),
//                     valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
//                     minHeight: 6,
//                   ),
//                   const SizedBox(height: 30),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isUploading = false;
//                         uploadModal = false;
//                         selectedFile = null;
//                       });
//                     },
//                     style: TextButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD1D5DB)),
//                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text('Cancel Upload', style: TextStyle(color: Color(0xFF1F2937))),
//                   ),
//                 ],
//               ),
//             ),
//           )
//               : Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Upload Documents',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1F2937),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Container(
//                   padding: const EdgeInsets.all(40),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFFBBF24), width: 2, style: BorderStyle.solid),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       const Icon(Icons.upload, size: 48, color: Color(0xFFFBBF24)),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Drag and drop files here',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text('or', style: TextStyle(color: Color(0xFF6B7280))),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: handleFileUpload,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFFBBF24),
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: const Text(
//                           'Browse Files',
//                           style: TextStyle(
//                             color: Color(0xFF1F2937),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Supported file types: .jpg, .png, .svg, .pdf, .docx',
//                         style: TextStyle(fontSize: 12, color: Color(0xFF6B7280),)
//                             // textAlign: TextAlign.center),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Files are end-to-end encrypted.',
//                   style: TextStyle(color: Color(0xFF6B7280)),
//                 ),
//                 if (selectedFile != null) ...[
//                   const SizedBox(height: 20),
//                   Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           offset: Offset(0, 1),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Selected: ${selectedFile!['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 5),
//                         Text('Size: ${selectedFile!['size']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
//                       ],
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: selectedFile != null ? simulateUpload : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: selectedFile != null ? const Color(0xFFFBBF24) : const Color(0xFFE5E7EB),
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: Text(
//                     'Upload to Vault',
//                     style: TextStyle(
//                       color: selectedFile != null ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (currentScreen == 'document' && selectedDocument != null) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
//             onPressed: () => setState(() => currentScreen = 'home'),
//           ),
//           title: const Text('Vault', style: TextStyle(fontWeight: FontWeight.bold)),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.person, color: Color(0xFF1F2937)),
//               onPressed: () {},
//             ),
//           ],
//           backgroundColor: Colors.white,
//           elevation: 1,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(30),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(() => currentScreen = 'home'),
//                     child: const Text('Vault', style: TextStyle(color: Color(0xFF6B7280))),
//                   ),
//                   const Text(' / ', style: TextStyle(color: Color(0xFF6B7280))),
//                   Text(selectedDocument!.name, style: const TextStyle(color: Color(0xFF1F2937))),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectedDocument!.name,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1F2937),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text('Encrypted', style: TextStyle(color: Color(0xFF6B7280))),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFE5E7EB),
//                           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                         ),
//                         child: const Text('Edit', style: TextStyle(color: Color(0xFF1F2937))),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   ...List.generate(
//                     15,
//                         (index) => Container(
//                       height: 20,
//                       width: index % 3 == 0 ? MediaQuery.of(context).size.width * 0.7 : double.infinity,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE5E7EB),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           offset: Offset(0, 1),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       selectedDocument!.content,
//                       style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937), height: 1.5),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.download, color: Color(0xFF1F2937)),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.print, color: Color(0xFF1F2937)),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.share, color: Color(0xFF1F2937)),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
//           onPressed: () {},
//         ),
//         title: const Text('Vault', style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person, color: Color(0xFF1F2937)),
//             onPressed: () {},
//           ),
//         ],
//         backgroundColor: Colors.white,
//         elevation: 1,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: categories.map((category) {
//                     final isSelected = selectedCategory == category.id;
//                     return GestureDetector(
//                       onTap: () => setState(() => selectedCategory = category.id),
//                       child: Container(
//                         width: (width - 50) / 4,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         decoration: BoxDecoration(
//                           color: isSelected ? category.color : Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               offset: Offset(0, 1),
//                               blurRadius: 3,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? Colors.white : category.color,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(
//                                 category.icon,
//                                 size: 24,
//                                 color: isSelected ? category.color : Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               category.name,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                                 color: isSelected ? Colors.white : const Color(0xFF1F2937),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFEF3C7),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.lock, size: 20, color: Color(0xFFD97706)),
//                     const SizedBox(width: 10),
//                     const Expanded(
//                       child: Text(
//                         'Vault Secured • Last access: 3 hours ago',
//                         style: TextStyle(color: Color(0xFFD97706)),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add, size: 20, color: Color(0xFFD97706)),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => setState(() => uploadModal = true),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         offset: Offset(0, 1),
//                         blurRadius: 3,
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add, size: 20, color: Color(0xFFFBBF24)),
//                       SizedBox(width: 10),
//                       Text(
//                         'Add Document',
//                         style: TextStyle(
//                           color: Color(0xFF1F2937),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: (width - 50) / 2 / 180,
//                 ),
//                 itemCount: getDocumentsByCategory().length,
//                 itemBuilder: (context, index) {
//                   final doc = getDocumentsByCategory()[index];
//                   return GestureDetector(
//                     onTap: () => setState(() {
//                       selectedDocument = doc;
//                       currentScreen = 'document';
//                     }),
//                     child: Container(
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             offset: Offset(0, 1),
//                             blurRadius: 3,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: getCategoryColor(doc.category),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Icon(getFileIcon(doc.type), size: 20, color: const Color(0xFF1F2937)),
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     doc.type.toUpperCase(),
//                                     style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFFEF3C7),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: const Text(
//                                       'SECURED',
//                                       style: TextStyle(fontSize: 8, color: Color(0xFFD97706)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             doc.name,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1F2937),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             'Updated ${doc.updatedTime}',
//                             style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFEF3C7),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Text(
//                               'SECURE CLOUD BACKUP',
//                               style: TextStyle(fontSize: 10, color: Color(0xFFD97706), fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 100),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => setState(() => uploadModal = true),
//         backgroundColor: const Color(0xFFFBBF24),
//         child: const Icon(Icons.add, color: Color(0xFF1F2937)),
//       ),
//     );
//   }
// }