import 'package:flutter/material.dart';
import 'vault_screen.dart';

class VaultPasswordScreen extends StatefulWidget {
  const VaultPasswordScreen({Key? key}) : super(key: key);

  @override
  State<VaultPasswordScreen> createState() => _VaultPasswordScreenState();
}

class _VaultPasswordScreenState extends State<VaultPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasPassword = false;
  String? _vaultPassword; // In-memory password storage

  @override
  void initState() {
    super.initState();
    _checkExistingPassword();
  }

  void _checkExistingPassword() {
    // Since SharedPreferences is removed, check in-memory password
    // For first-time use, _vaultPassword is null, so _hasPassword is false
    setState(() {
      _hasPassword = _vaultPassword != null && _vaultPassword!.isNotEmpty;
    });
  }

  Future<void> _handlePasswordSubmit() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    if (_passwordController.text.length < 4) {
      setState(() {
        _errorMessage = 'Password must be at least 4 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_hasPassword) {
      // Verify existing password
      if (_passwordController.text == _vaultPassword) {
        _navigateToVault();
      } else {
        setState(() {
          _errorMessage = 'Incorrect password';
          _isLoading = false;
        });
      }
    } else {
      // Set new password
      _vaultPassword = _passwordController.text;
      _navigateToVault();
    }
  }

  void _navigateToVault() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const VaultScreen(),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Forgot Password'),
            content: const Text(
                'To reset your vault password, you will lose access to all previously stored documents. Are you sure you want to continue?'),
            actions: <Widget>[
        TextButton(
        child: const Text('Cancel'),
        onPressed: () {
        Navigator.of(context).pop();
        },
        ),
        TextButton(
        child: const Text('Reset', style: TextStyle(color: Colors.red)),
        onPressed: () {
        setState(() {
        _vaultPassword = null;
        _hasPassword = false;
        _passwordController.clear();
        _errorMessage = null;
        });
        Navigator.of(context).pop();
        },
        ),
        ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Vault Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFED29).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security,
                  size: 50,
                  color: Color(0xFFFFD700),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                _hasPassword ? 'Enter Vault Password' : 'Create Vault Password',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                _hasPassword
                    ? 'Enter your password to access the vault'
                    : 'Create a password to secure your documents',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Password Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorMessage != null ? Colors.red : Colors.grey[300]!,
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: !_isPasswordVisible,
                  onSubmitted: (_) => _handlePasswordSubmit(),
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              // Error Message
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePasswordSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                      : Text(
                    _hasPassword ? 'Unlock Vault' : 'Create Password',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Forgot Password
              if (_hasPassword) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}