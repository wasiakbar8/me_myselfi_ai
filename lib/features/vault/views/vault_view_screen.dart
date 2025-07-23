// lib/features/vault/views/vault_view_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';
import 'vault_screen.dart';
import '../../../shared/widgets/custom_app_bar.dart';

//
// Future<void> _openDocument() async {
//   try {
//     final dir = await getApplicationDocumentsDirectory(); // or getTemporaryDirectory()
//     final localPath = '${dir.path}/${widget.document.localFileName}';
//     final file = File(localPath);
//
//     if (await file.exists()) {
//       // ✅ File already downloaded
//       await OpenFilex.open(localPath);
//     } else {
//       // ❌ File not available — download from AWS
//       final response = await Dio().download(
//         widget.document.filePath, // remote URL
//         localPath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             debugPrint("Downloading: ${(received / total * 100).toStringAsFixed(0)}%");
//           }
//         },
//       );
//
//       if (response.statusCode == 200) {
//         await OpenFilex.open(localPath);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to download document.')),
//         );
//       }
//     }
//   } catch (e) {
//     debugPrint('Open Document Error: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error opening document: $e')),
//     );
//   }
// }


class VaultViewScreen extends StatefulWidget {
  final VaultDocument document;
  final VoidCallback onDelete;

  const VaultViewScreen({
    Key? key,
    required this.document,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<VaultViewScreen> createState() => _VaultViewScreenState();
}

class _VaultViewScreenState extends State<VaultViewScreen> {

  String _getCategoryName(VaultCategory category) {
    switch (category) {
      case VaultCategory.allDocs:
        return 'All Docs';
      case VaultCategory.bank:
        return 'Bank';
      case VaultCategory.medical:
        return 'Medical';
      case VaultCategory.legal:
        return 'Legal';
      case VaultCategory.personal:
        return 'Personal';
    }
  }

  Color _getCategoryColor(VaultCategory category) {
    switch (category) {
      case VaultCategory.allDocs:
        return const Color(0xFFFFD700);
      case VaultCategory.bank:
        return Colors.blue;
      case VaultCategory.medical:
        return Colors.red;
      case VaultCategory.legal:
        return Colors.purple;
      case VaultCategory.personal:
        return Colors.green;
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.green;
      case 'xls':
      case 'xlsx':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${widget.document.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close view screen
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDocumentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality not implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download functionality not implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Document Details',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },


      ),
      drawer: HamburgerDrawer(onItemSelected: (index) {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getFileTypeColor(widget.document.fileType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getFileTypeIcon(widget.document.fileType),
                      color: _getFileTypeColor(widget.document.fileType),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.document.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(widget.document.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getCategoryName(widget.document.category),
                      style: TextStyle(
                        color: _getCategoryColor(widget.document.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Document Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Document Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('File Name', widget.document.name),
                  _buildDetailRow('File Type', widget.document.fileType.toUpperCase()),
                  _buildDetailRow('Category', _getCategoryName(widget.document.category)),
                  _buildDetailRow('File Size', widget.document.formattedSize),
                  _buildDetailRow('Uploaded On', _formatDate(widget.document.uploadedAt)),
                  _buildDetailRow('Last Accessed', widget.document.timeAgo),


              // String filePath; // remote URL (from AWS)
              // String localFileName; // like "abc.pdf"



              ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Open document functionality not implemented')),
                      );
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Document'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),

                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _showDocumentOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.more_horiz),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Security Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFED29).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFED29).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security,
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This document is securely encrypted and stored in your vault',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}