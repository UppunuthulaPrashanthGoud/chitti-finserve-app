import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';

class EmiScreen extends StatefulWidget {
  const EmiScreen({Key? key}) : super(key: key);

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> with TickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _rateController = TextEditingController();
  double? _emi;
  double? _totalAmount;
  double? _totalInterest;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateEmi() {
    final principal = double.tryParse(_amountController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    
    if (principal > 0 && tenure > 0 && rate > 0) {
      final monthlyRate = rate / 12 / 100;
      final emi = (principal * monthlyRate * (pow(1 + monthlyRate, tenure))) /
          (pow(1 + monthlyRate, tenure) - 1);
      final totalAmount = emi * tenure;
      final totalInterest = totalAmount - principal;
      
      setState(() {
        _emi = emi;
        _totalAmount = totalAmount;
        _totalInterest = totalInterest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    
                    const SizedBox(height: 32),
                    
                    // Calculator Card
                    _buildCalculatorCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Results Card
                    if (_emi != null) _buildResultsCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            Icons.calculate_outlined,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'EMI Calculator',
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        const SizedBox(height: 8),
        Text(
          'Calculate your monthly EMI easily',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Text(
              'Enter Loan Details',
              style: TextStyle(
                color: const Color(0xFF005DFF),
                fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Loan Amount
            _buildInputField(
                    controller: _amountController,
              label: 'Loan Amount',
              icon: Icons.currency_rupee,
              hint: 'Enter loan amount',
              formatter: FilteringTextInputFormatter.digitsOnly,
                  ),
            
                  const SizedBox(height: 20),
            
            // Tenure
            _buildInputField(
                    controller: _tenureController,
              label: 'Tenure (months)',
              icon: Icons.calendar_today,
              hint: 'Enter tenure in months',
              formatter: FilteringTextInputFormatter.digitsOnly,
                  ),
            
                  const SizedBox(height: 20),
            
            // Interest Rate
            _buildInputField(
                    controller: _rateController,
              label: 'Interest Rate (%)',
              icon: Icons.percent,
              hint: 'Enter interest rate',
              formatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ),
            
                  const SizedBox(height: 32),
            
            // Calculate Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                    ),
                    onPressed: _calculateEmi,
                    child: const Text('Calculate EMI'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputFormatter? formatter,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: formatter != null ? [formatter] : null,
      style: const TextStyle(fontFamily: 'Montserrat'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF005DFF)),
        filled: true,
        fillColor: Colors.grey[50],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
        ),
      ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.green[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
                        child: Column(
                          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
                            Text(
              'EMI Calculation Results',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
                              textAlign: TextAlign.center,
                            ),
            const SizedBox(height: 24),
            
            // Results Grid
            Row(
              children: [
                Expanded(
                  child: _buildResultItem(
                    'Monthly EMI',
                    '₹${_emi!.toStringAsFixed(2)}',
                    Icons.payment,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResultItem(
                    'Total Amount',
                    '₹${_totalAmount!.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildResultItem(
              'Total Interest',
              '₹${_totalInterest!.toStringAsFixed(2)}',
              Icons.trending_up,
              Colors.red,
            ),
                          ],
                        ),
                      ),
    );
  }

  Widget _buildResultItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
                    ),
                ],
              ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
