import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF59D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Effective: January 2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please read these terms carefully before using our AI-powered platform and services. By accessing our platform, you agree to be bound by these terms.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Service Agreement
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Agreement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAgreementItem('✓', 'AI Services Access', 'Full access to all AI-powered features'),
                  _buildAgreementItem('✓', 'Data Processing', 'Secure handling of your information'),
                  _buildAgreementItem('✓', 'Platform Updates', 'Regular improvements and new features'),
                  _buildAgreementItem('✓', 'Customer Support', '24/7 technical assistance'),
                  _buildAgreementItem('✓', 'Service Reliability', '99.9% uptime guarantee'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Terms Sections
            _buildTermsSection(
              'Acceptance of Terms',
              'By creating an account and using our AI services platform, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. These terms apply to all users of our Vault, Unified Inbox, Smart Calendar, AI Assistant, Diary, Budget Tracking, and AI Voice Agent services.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'Service Description',
              'Our platform provides AI-powered productivity and management tools including secure document storage (Vault), centralized messaging (Unified Inbox), intelligent scheduling (Smart Calendar), automated assistance (AI Assistant), personal journaling (Diary), financial tracking (Budget Tracking), and voice interactions (AI Voice Agent). These services are designed to enhance your productivity and streamline your digital workflow.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'User Responsibilities',
              'You are responsible for maintaining the confidentiality of your account credentials, providing accurate information, using services in compliance with applicable laws, respecting intellectual property rights, and not engaging in any harmful or disruptive activities. You must not attempt to reverse engineer, hack, or misuse our AI systems.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'AI Services Usage',
              'Our AI services process your data to provide intelligent features and recommendations. By using these services, you grant us permission to analyze your data for service improvement. AI-generated content and suggestions are provided as-is and should be reviewed before implementation. We are not liable for decisions made based on AI recommendations.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'Data Ownership & Rights',
              'You retain ownership of all data you upload or create using our services. We claim no ownership rights over your content. However, you grant us a license to process, store, and analyze your data to provide our services. We will not share your personal data with third parties without your explicit consent, except as required by law.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'Service Availability',
              'We strive to maintain 99.9% service uptime but cannot guarantee uninterrupted access. Scheduled maintenance will be announced in advance. We reserve the right to modify, suspend, or discontinue services with reasonable notice. Premium features may require subscription plans with specific terms and billing cycles.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'Limitation of Liability',
              'Our services are provided "as-is" without warranties. We are not liable for indirect, incidental, or consequential damages arising from service use. Our total liability is limited to the amount paid for services in the preceding 12 months. This limitation applies to all claims, whether based on contract, tort, or other legal theories.',
            ),

            const SizedBox(height: 16),

            _buildTermsSection(
              'Account Termination',
              'You may terminate your account at any time through account settings. We may suspend or terminate accounts for terms violations, illegal activities, or extended inactivity. Upon termination, you will lose access to services, but we will provide reasonable time to export your data. Paid subscriptions will be handled according to our refund policy.',
            ),

            const SizedBox(height: 20),

            // Important Notice Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF59D), Color(0xFFFFF176)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.black87,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Important Notice',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'These terms are subject to change. We will notify users of significant changes via email or platform notifications. Continued use after changes constitutes acceptance of new terms.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle contact legal team
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Contact Legal Team',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle download terms
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Colors.black87),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Download PDF',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF59D).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF176),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}