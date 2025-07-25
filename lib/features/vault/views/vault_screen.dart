import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_app_bar.dart';

import '../../dashboard/presentation/widgets/chat_bot.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';
import 'vault_newentry_screen.dart';
import 'vault_view_screen.dart';

enum VaultCategory { allDocs, bank, medical, legal, personal }

class VaultDocument {
  final String id;
  final String name;
  final String filePath;
  final VaultCategory category;
  final String fileType; // pdf, doc, image, etc.
  final DateTime uploadedAt;
  final int fileSize;

  VaultDocument({
    required this.id,
    required this.name,
    required this.filePath,
    required this.category,
    required this.fileType,
    required this.uploadedAt,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'category': category.index,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
      'fileSize': fileSize,
    };
  }

  factory VaultDocument.fromJson(Map<String, dynamic> json) {
    return VaultDocument(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      category: VaultCategory.values[json['category']],
      fileType: json['fileType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      fileSize: json['fileSize'],
    );
  }

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(uploadedAt);

    if (difference.inDays > 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  VaultCategory _selectedCategory = VaultCategory.allDocs;
  List<VaultDocument> _allDocuments = [];
  List<VaultDocument> _filteredDocuments = [];
  String _lastAccessTime = '';

  // Sample documents
  final List<VaultDocument> _sampleDocuments = [
    VaultDocument(
      id: '1',
      name: 'Passport Copy',
      filePath: '/vault/passport_copy.pdf',
      category: VaultCategory.personal,
      fileType: 'pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
      fileSize: 1024 * 500, // 500KB
    ),
    VaultDocument(
      id: '2',
      name: 'Insurance Policy',
      filePath: '/vault/insurance_policy.pdf',
      category: VaultCategory.bank,
      fileType: 'pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
      fileSize: 1024 * 800, // 800KB
    ),
    VaultDocument(
      id: '3',
      name: 'Diploma Certificate',
      filePath: '/vault/diploma.doc',
      category: VaultCategory.personal,
      fileType: 'doc',
      uploadedAt: DateTime.now().subtract(const Duration(days: 7)),
      fileSize: 1024 * 300, // 300KB
    ),
    VaultDocument(
      id: '4',
      name: 'Medical Report',
      filePath: '/vault/medical_report.pdf',
      category: VaultCategory.medical,
      fileType: 'pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 10)),
      fileSize: 1024 * 1200, // 1.2MB
    ),
    VaultDocument(
      id: '5',
      name: 'Resume 2025',
      filePath: '/vault/resume.doc',
      category: VaultCategory.personal,
      fileType: 'doc',
      uploadedAt: DateTime.now().subtract(const Duration(days: 14)),
      fileSize: 1024 * 250, // 250KB
    ),
    VaultDocument(
      id: '6',
      name: 'Social Security Card',
      filePath: '/vault/social_security.pdf',
      category: VaultCategory.legal,
      fileType: 'pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 21)),
      fileSize: 1024 * 150, // 150KB
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
    _loadLastAccessTime();
  }

  void _loadDocuments() {
    // Initialize with sample documents (no SharedPreferences)
    _allDocuments = _sampleDocuments;
    _filterDocuments();
  }

  void _loadLastAccessTime() {
    // Since there's no SharedPreferences, we'll set a default or in-memory last access time
    final now = DateTime.now();
    setState(() {
      _lastAccessTime = 'Last accessed • Recently';
    });
  }

  void _filterDocuments() {
    setState(() {
      if (_selectedCategory == VaultCategory.allDocs) {
        _filteredDocuments = List.from(_allDocuments);
      } else {
        _filteredDocuments = _allDocuments
            .where((doc) => doc.category == _selectedCategory)
            .toList();
      }
      // Sort by upload date (newest first)
      _filteredDocuments.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    });
  }

  void _selectCategory(VaultCategory category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterDocuments();
  }

  Future<void> _addNewDocument() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VaultNewEntryScreen(),
      ),
    );

    if (result != null && result is VaultDocument) {
      setState(() {
        _allDocuments.insert(0, result);
      });
      _filterDocuments();
    }
  }

  void _deleteDocument(VaultDocument document) {
    setState(() {
      _allDocuments.removeWhere((doc) => doc.id == document.id);
    });
    _filterDocuments();
  }

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

  IconData _getCategoryIcon(VaultCategory category) {
    switch (category) {
      case VaultCategory.allDocs:
        return Icons.folder;
      case VaultCategory.bank:
        return Icons.account_balance;
      case VaultCategory.medical:
        return Icons.local_hospital;
      case VaultCategory.legal:
        return Icons.gavel;
      case VaultCategory.personal:
        return Icons.person;
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

  int _getCategoryCount(VaultCategory category) {
    if (category == VaultCategory.allDocs) {
      return _allDocuments.length;
    }
    return _allDocuments.where((doc) => doc.category == category).length;
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

  Widget _buildCategoryFilter(VaultCategory category) {
    final isSelected = _selectedCategory == category;
    final categoryCount = _getCategoryCount(category);

    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x80FFED29) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFED29) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 28,
              color: isSelected ? Colors.black87 : _getCategoryColor(category),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  _getCategoryName(category),
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(

                    color: isSelected ? Colors.black26 : _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    categoryCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile(VaultDocument document) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VaultViewScreen(
              document: document,
              onDelete: () => _deleteDocument(document),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // File Type Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getFileTypeColor(document.fileType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileTypeIcon(document.fileType),
                color: _getFileTypeColor(document.fileType),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Document Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Updated • ${document.timeAgo}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // File Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(document.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    document.fileType.toUpperCase(),
                    style: TextStyle(
                      color: _getCategoryColor(document.category),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  document.formattedSize,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Vault',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },

      ),
      drawer: HamburgerDrawer(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),


              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: VaultCategory.values
                        .map((category) => _buildCategoryFilter(category))
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

// Last Access Info
              if (_lastAccessTime.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFFFED29).withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _lastAccessTime,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _addNewDocument,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD60A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add Document',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),

              const SizedBox(height: 16),


              // Documents List
              Expanded(
                child: _filteredDocuments.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No documents found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _addNewDocument,
                        child: const Text(
                          'Tap here to upload your first document',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredDocuments.length,
                  itemBuilder: (context, index) {
                    return _buildDocumentTile(_filteredDocuments[index]);
                  },
                ),
              ),
            ],
          ),
          const ChatBotWidget(),
        ],
      ),

    );
  }
}