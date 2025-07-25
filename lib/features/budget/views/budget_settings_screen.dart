// lib/features/budget/views/budget_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/budget_model.dart';
import '../utils/budget_helper.dart';

class BudgetSettingsScreen extends StatefulWidget {
  final BudgetSettings? currentSettings;

  const BudgetSettingsScreen({Key? key, this.currentSettings}) : super(key: key);

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weeklyBudgetController = TextEditingController();
  final _monthlyBudgetController = TextEditingController();

  BudgetPeriod _selectedPeriod = BudgetPeriod.weekly;
  Map<BudgetCategory, TextEditingController> _categoryControllers = {};
  bool _isFirstTimeSetup = false;

  @override
  void initState() {
    super.initState();
    _isFirstTimeSetup = widget.currentSettings == null;

    // Initialize category controllers
    for (var category in BudgetCategory.values) {
      if (category != BudgetCategory.all) {
        _categoryControllers[category] = TextEditingController();
      }
    }

    if (widget.currentSettings != null) {
      final settings = widget.currentSettings!;
      _weeklyBudgetController.text = settings.weeklyBudget.toString();
      _monthlyBudgetController.text = settings.monthlyBudget.toString();
      _selectedPeriod = settings.activePeriod;

      // Load category limits
      settings.categoryLimits.forEach((category, limit) {
        if (_categoryControllers.containsKey(category)) {
          _categoryControllers[category]!.text = limit.toString();
        }
      });
    }
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      Map<BudgetCategory, double> categoryLimits = {};

      _categoryControllers.forEach((category, controller) {
        if (controller.text.isNotEmpty) {
          categoryLimits[category] = double.parse(controller.text);
        }
      });

      final settings = BudgetSettings(
        weeklyBudget: double.parse(_weeklyBudgetController.text),
        monthlyBudget: double.parse(_monthlyBudgetController.text),
        activePeriod: _selectedPeriod,
        categoryLimits: categoryLimits,
      );

      Navigator.pop(context, settings);
    }
  }

  Widget _buildBudgetPeriodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget Period',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = BudgetPeriod.weekly;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == BudgetPeriod.weekly
                        ? const Color(0xFFFFD700)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedPeriod == BudgetPeriod.weekly
                          ? const Color(0xFFFFD700)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    'Weekly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedPeriod == BudgetPeriod.weekly
                          ? Colors.black87
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = BudgetPeriod.monthly;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == BudgetPeriod.monthly
                        ? const Color(0xFFFFD700)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedPeriod == BudgetPeriod.monthly
                          ? const Color(0xFFFFD700)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    'Monthly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedPeriod == BudgetPeriod.monthly
                          ? Colors.black87
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetAmountFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget Amounts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Weekly Budget
        TextFormField(
          controller: _weeklyBudgetController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Weekly Budget',
            hintText: '0.00',
            prefixText: '\$ ',
            prefixStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter weekly budget';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Monthly Budget
        TextFormField(
          controller: _monthlyBudgetController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Monthly Budget',
            hintText: '0.00',
            prefixText: '\$ ',
            prefixStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter monthly budget';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryLimits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Limits (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set spending limits for specific categories',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),

        ..._categoryControllers.entries.map((entry) {
          final category = entry.key;
          final controller = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: BudgetHelper.getCategoryName(category),
                hintText: '0.00',
                prefixIcon: Icon(
                  BudgetHelper.getCategoryIcon(category),
                  color: BudgetHelper.getCategoryColor(category),
                  size: 20,
                ),
                prefixText: '\$ ',
                prefixStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFFD700)),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isFirstTimeSetup ? 'Setup Budget' : 'Budget Settings',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'Save',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isFirstTimeSetup) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8DC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFFFD700)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Welcome! Let\'s set up your budget to start tracking your expenses effectively.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              _buildBudgetPeriodSelector(),
              const SizedBox(height: 24),

              _buildBudgetAmountFields(),
              const SizedBox(height: 24),

              _buildCategoryLimits(),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    _isFirstTimeSetup ? 'Setup Budget' : 'Update Settings',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weeklyBudgetController.dispose();
    _monthlyBudgetController.dispose();
    _categoryControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}