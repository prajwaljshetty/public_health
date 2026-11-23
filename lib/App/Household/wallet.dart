import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Provider
import 'package:public_health/Providers/User/user.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Language/language_switcher.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Lottie
import 'package:lottie/lottie.dart';

// Profile
import 'package:public_health/App/Household/profile.dart';

// API
import 'package:public_health/Services/API/Household/api_service.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  int _points = 0;
  bool _isLoading = true;
  String? _errorMessage;

  //static const _animationDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPoints();
    });
  }

  Future<void> _loadPoints() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final result = await ApiService.getPoints(userprovider: userProvider);

      if (!mounted) return;

      if (result['status'] != true) {
        throw Exception(result['message'] ?? 'Unable to load points.');
      }

      setState(() {
        _points = (result['points'] as num).toInt();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Widget _buildPointsValue() {
    if (_isLoading) {
      return const SizedBox(
        height: 62,
        child: Align(
          alignment: Alignment.centerLeft,
          child: CupertinoActivityIndicator(
            color: AppColors.backgroundwhite,
            radius: 14,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 62,
        child: Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _loadPoints,
            child: const Icon(
              CupertinoIcons.refresh,
              color: AppColors.backgroundwhite,
              size: 28,
            ),
          ),
        ),
      );
    }

    return Text(
      '$_points',
      style: AppText.title.copyWith(
        color: AppColors.backgroundwhite,
        fontSize: 52,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            color: AppColors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage ?? l10n.somethingWentWrong,
              style: AppText.cardSubtitle.copyWith(
                color: AppColors.red,
                fontSize: 13,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: _loadPoints,
            child: Text(
              l10n.tryAgain,
              style: AppText.button.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: true,
      trailing: [
        LanguageSwitcher(),
        const Spacer(),
        AppIcon(
          icon: CupertinoIcons.person_fill,
          onClick: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          Text(
            l10n.walletTitle,
            style: AppText.title.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(l10n.walletSubtitle, style: AppText.cardSubtitle),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.creditcard,
                      color: AppColors.backgroundwhite,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.walletTotalBalance,
                      style: AppText.title.copyWith(
                        color: AppColors.backgroundwhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPointsValue(),

                          Text(
                            l10n.points,
                            style: AppText.title.copyWith(
                              color: AppColors.backgroundwhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Lottie.asset(
                      AssetMapper.coins,
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                if (_errorMessage != null) _buildErrorState(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundwhite,
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundwhite,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    CupertinoIcons.gift,
                    size: 28,
                    color: AppColors.accent,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.walletEarnPoints, style: AppText.cardTitle),
                      const SizedBox(height: 6),
                      Text(
                        l10n.walletEarnPointsDescription,
                        style: AppText.cardSubtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
