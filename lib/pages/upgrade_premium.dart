import 'package:flutter/material.dart';

class UpgradePremiumPage extends StatefulWidget {
  const UpgradePremiumPage({Key? key}) : super(key: key);

  @override
  State<UpgradePremiumPage> createState() => _UpgradePremiumPageState();
}

class _UpgradePremiumPageState extends State<UpgradePremiumPage> {
  int selectedPlan = 1; // 0 for trial, 1 for business

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upgrade Premium',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Header
                Text(
                  'Simple, Transparent Pricing',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Choose the plan that fits your needs.',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: const Color(0xFF718096),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Pricing Cards - Stack vertically on mobile
                Column(
                  children: [
                    // Trial Plan Card
                    GestureDetector(
                      onTap: () => setState(() => selectedPlan = 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedPlan == 0
                                ? const Color(0xFFECC94B)
                                : Colors.grey.shade300,
                            width: selectedPlan == 0 ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TrialPlanCard(isSmallScreen: isSmallScreen),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Business Plan Card
                    GestureDetector(
                      onTap: () => setState(() => selectedPlan = 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedPlan == 1
                                ? const Color(0xFFECC94B)
                                : Colors.grey.shade300,
                            width: selectedPlan == 1 ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: BusinessPlanCard(isSmallScreen: isSmallScreen),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Terms and Privacy
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpgrade() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          selectedPlan == 0
              ? 'Starting free trial...'
              : 'Upgrading to Business plan...',
        ),
        backgroundColor: const Color(0xFFECC94B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class TrialPlanCard extends StatelessWidget {
  final bool isSmallScreen;

  const TrialPlanCard({Key? key, required this.isSmallScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            '1 Month Trial Plan',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Perfect for personal use',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: const Color(0xFF718096),
            ),
          ),

          const SizedBox(height: 16),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$0',
                style: TextStyle(
                  fontSize: isSmallScreen ? 36 : 42,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'for 30 days',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Features
          FeatureItem(
            text: 'Basic dashboard access',
            isIncluded: true,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: 'Single calendar profile',
            isIncluded: true,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: 'Basic voice assistant',
            isIncluded: true,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: 'Standard message management',
            isIncluded: true,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: '1GB vault storage',
            isIncluded: true,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: 'No AI call handling',
            isIncluded: false,
            isSmallScreen: isSmallScreen,
          ),
          FeatureItem(
            text: 'No API integrations',
            isIncluded: false,
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFFFFD60A),

                foregroundColor: Colors.black87,

                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),

                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BusinessPlanCard extends StatelessWidget {
  final bool isSmallScreen;

  const BusinessPlanCard({Key? key, required this.isSmallScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        Padding(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              // Header with spacing for badge
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Business Plan',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'For professionals and teams',
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: const Color(0xFF718096),
                ),
              ),

              const SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$12.99',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 36 : 42,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'per month',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Features
              FeatureItem(
                text: 'Advanced dashboard with analytics',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: 'Dual calendar profiles (work/personal)',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: 'Premium voice assistant with custom commands',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: 'AI-powered message prioritization',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: '10GB vault storage',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: 'Full AI call handling',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),
              FeatureItem(
                text: 'API integrations & custom workflows',
                isIncluded: true,
                isSmallScreen: isSmallScreen,
              ),

              const SizedBox(height: 20),

              // Button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFFFD60A),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD60A),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Upgrade to Business',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Recommended badge
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 10 : 12,
              vertical: isSmallScreen ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFECC94B),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'RECOMMENDED',
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;
  final bool isIncluded;
  final bool isSmallScreen;

  const FeatureItem({
    Key? key,
    required this.text,
    required this.isIncluded,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isIncluded
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncluded ? Icons.check : Icons.close,
              size: isSmallScreen ? 16 : 18,
              color: isIncluded ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: isIncluded ? const Color(0xFF2D3748) : Colors.grey.shade500,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}