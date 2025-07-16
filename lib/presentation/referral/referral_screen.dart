import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'referral_provider.dart';
import '../../data/model/referral_model.dart';
import '../../core/app_theme.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_screen.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _referralCodeController = TextEditingController();
  bool _showReferralInput = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Builder(
        builder: (context) {
          try {
            final referralDataAsync = ref.watch(referralDataProvider);

            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),
                      
                      // Main Content
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: referralDataAsync.when(
                            data: (referralData) => _buildContent(referralData),
                            loading: () => _buildLoadingState(),
                            error: (e, _) => _buildErrorState(e),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } catch (e) {
            // Fallback UI in case of any errors
            return Scaffold(
              appBar: AppBar(
                title: const Text('Refer & Earn'),
                backgroundColor: const Color(0xFF005DFF),
                foregroundColor: Colors.white,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  print('🔙 ReferralScreen: Back button pressed');
                  print('🔙 ReferralScreen: Can pop: ${Navigator.canPop(context)}');
                  
                  // Check if user is authenticated
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('auth_token');
                  
                  if (token != null && token.isNotEmpty) {
                    // User is authenticated, try to pop back
                    if (Navigator.canPop(context)) {
                      print('🔙 ReferralScreen: Popping back to previous screen');
                      Navigator.pop(context);
                    } else {
                      print('🔙 ReferralScreen: Cannot pop, navigating to main nav');
                      // Go to main navigation with home tab
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavScreen(initialIndex: 0),
                        ),
                      );
                    }
                  } else {
                    print('🔙 ReferralScreen: No auth token, going to login');
                    // User not authenticated, go to login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  'Refer & Earn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => _refreshData(),
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
              const SizedBox(width: 8), // Balance for back button
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Share your referral code and earn ₹100 for each friend who joins!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ReferralDataModel referralData) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Wallet Card
          _buildWalletCard(referralData.wallet),
          
          // Referral Code Section
          _buildReferralCodeSection(referralData),
          
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF005DFF),
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              tabs: const [
                Tab(text: 'Statistics'),
                Tab(text: 'Referrals'),
                Tab(text: 'Transactions'),
              ],
            ),
          ),
          
          // Tab Content with fixed height
          Container(
            height: 400, // Fixed height to prevent overflow
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatisticsTab(referralData.statistics),
                _buildReferralsTab(referralData.referrals),
                _buildTransactionsTab(),
              ],
            ),
          ),
          
          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWalletCard(WalletModel wallet) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          const Text(
            'Wallet Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${wallet.balance.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildWalletStat('Total Earned', '₹${wallet.totalEarned.toStringAsFixed(0)}')),
              const SizedBox(width: 8),
              Expanded(child: _buildWalletStat('Total Withdrawn', '₹${wallet.totalWithdrawn.toStringAsFixed(0)}')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showWithdrawalDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF005DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Withdraw',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _shareReferralCode(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Share Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletStat(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontFamily: 'Montserrat',
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildReferralCodeSection(ReferralDataModel referralData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: Color(0xFF005DFF)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Your Referral Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              if (referralData.referredBy != null)
                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                    'Referred by ${referralData.referredBy!.name}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF005DFF)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralData.referralCode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      letterSpacing: 2,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyReferralCode(referralData.referralCode),
                  icon: const Icon(Icons.copy, color: Color(0xFF005DFF)),
                ),
              ],
            ),
          ),
          if (referralData.referredBy == null) ...[
            const SizedBox(height: 16),
            if (!_showReferralInput)
              ElevatedButton(
                onPressed: () => setState(() => _showReferralInput = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enter Referral Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              )
            else
              _buildReferralCodeInput(),
          ],
        ],
      ),
    );
  }

  Widget _buildReferralCodeInput() {
    return Column(
      children: [
        TextField(
          controller: _referralCodeController,
          decoration: InputDecoration(
            hintText: 'Enter referral code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          textCapitalization: TextCapitalization.characters,
                  ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _applyReferralCode(),
                    style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _showReferralInput = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsTab(ReferralStatisticsModel statistics) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard('Total Referrals', statistics.totalReferrals.toString(), Icons.people),
          const SizedBox(height: 16),
          _buildStatCard('Completed Referrals', statistics.completedReferrals.toString(), Icons.check_circle),
          const SizedBox(height: 16),
          _buildStatCard('Pending Referrals', statistics.pendingReferrals.toString(), Icons.pending),
          const SizedBox(height: 16),
          _buildStatCard('Total Earned', '₹${statistics.totalEarned.toStringAsFixed(0)}', Icons.monetization_on),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF005DFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF005DFF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralsTab(List<ReferralModel> referrals) {
    if (referrals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No referrals yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Share your referral code to start earning!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: referrals.length,
      itemBuilder: (context, index) {
        final referral = referrals[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 600),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _buildReferralCard(referral),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReferralCard(ReferralModel referral) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF005DFF).withOpacity(0.1),
            child: Text(
              referral.referredUser.name[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF005DFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.referredUser.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  referral.referredUser.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  'Joined ${_formatDate(referral.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: referral.status == 'completed' 
                      ? Colors.green.shade100 
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  referral.status.toUpperCase(),
                  style: TextStyle(
                    color: referral.status == 'completed' 
                        ? Colors.green.shade700 
                        : Colors.orange.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                    ),
              const SizedBox(height: 4),
              Text(
                '₹${referral.bonusAmount}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005DFF),
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final transactionsAsync = ref.watch(walletTransactionsProvider('1_20'));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(walletTransactionsProvider('1_20'));
      },
      child: transactionsAsync.when(
        data: (transactionsData) {
          if (transactionsData.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: transactionsData.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionsData.transactions[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildTransactionCard(transaction),
                  ),
                ),
              );
            },
          );
        },
        loading: () => _buildLoadingState(),
        error: (e, _) => _buildErrorState(e),
      ),
    );
  }

  Widget _buildTransactionCard(WalletTransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.type == 'credit' 
                  ? Colors.green.shade100 
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.type == 'credit' ? Icons.add : Icons.remove,
              color: transaction.type == 'credit' 
                  ? Colors.green.shade700 
                  : Colors.red.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  ),
                Text(
                  _formatDate(transaction.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.type == 'credit' ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == 'credit' 
                      ? Colors.green.shade700 
                      : Colors.red.shade700,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                'Balance: ₹${transaction.balance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005DFF)),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyReferralCode(String code) {
    // Implementation for copying to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral code copied: $code'),
        backgroundColor: const Color(0xFF005DFF),
      ),
    );
  }

  void _refreshData() {
    print('🔄 ReferralScreen: Manually refreshing data');
    ref.invalidate(referralDataProvider);
    ref.invalidate(walletTransactionsProvider('1_20'));
    ref.invalidate(shareReferralDataProvider);
  }

  void _shareReferralCode() async {
    try {
      final shareDataAsync = ref.read(shareReferralDataProvider);
      final shareData = await shareDataAsync.when(
        data: (data) => data,
        loading: () => throw Exception('Loading share data'),
        error: (e, _) => throw e,
      );

      await Share.share(
        shareData.shareMessage,
        subject: 'Join Chitti Finserve',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _applyReferralCode() async {
    final code = _referralCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a referral code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final applicationNotifier = ref.read(referralCodeApplicationProvider.notifier);
    await applicationNotifier.applyReferralCode(code);

    final state = ref.read(referralCodeApplicationProvider);
    state.when(
      data: (data) {
        if (data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Referral code applied successfully! Earned ₹${data['bonusAmount']}'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _showReferralInput = false;
            _referralCodeController.clear();
          });
          // Refresh referral data and wallet transactions
          ref.invalidate(referralDataProvider);
          ref.invalidate(walletTransactionsProvider('1_20'));
          // Reset application state
          ref.read(referralCodeApplicationProvider.notifier).reset();
        }
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to apply referral code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _showWithdrawalDialog() {
    final amountController = TextEditingController();
    final bankDetailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Withdrawal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bankDetailsController,
              decoration: const InputDecoration(
                labelText: 'Bank Details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              final bankDetails = bankDetailsController.text.trim();

              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (bankDetails.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter bank details'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context);

              final withdrawalNotifier = ref.read(withdrawalRequestProvider.notifier);
              await withdrawalNotifier.requestWithdrawal(
                amount: amount,
                bankDetails: bankDetails,
              );

              final state = ref.read(withdrawalRequestProvider);
              state.when(
                data: (data) {
                  if (data != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Withdrawal request submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    ref.invalidate(referralDataProvider);
                  }
                },
                loading: () {},
                error: (e, _) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to submit withdrawal request: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
