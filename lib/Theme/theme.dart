import 'package:flutter/cupertino.dart';

class AppColors {
  static const background = CupertinoColors.white;
  static const surface = Color(0xFFF5F7F7);
  static const border = Color(0xFFE7ECEB);
  static const accent = Color(0xFF19673F);
  static const accentSoft = Color(0xFFE2F1E8);
  static const hero = Color(0xFFE8E3D0);
  static const textPrimary = CupertinoColors.black;
  static const textSecondary = CupertinoColors.systemGrey;
}

class AppText {
  static const title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: AppColors.textPrimary,
  );
  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const cardSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
  static const caption = TextStyle(
    fontSize: 12.5,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  static const button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: CupertinoColors.white,
  );
}

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottom;
  final Widget? trailing; // top-right widget
  final bool showBack;

  const AppScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.trailing,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: body,
                    ),
                  ),
                  if (bottom != null) bottom!,
                ],
              ),
            ),
            if (showBack)
              Positioned(
                top: 0,
                left: 8,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.chevron_left,
                    size: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            if (trailing != null)
              Positioned(top: 8, right: 22, child: trailing!),
          ],
        ),
      ),
    );
  }
}

class AppOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const AppOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.hero, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.cardTitle),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppText.cardSubtitle),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            keyboardType: keyboardType,
            obscureText: obscureText,
            autocorrect: !obscureText,
            enableSuggestions: !obscureText,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(color: CupertinoColors.transparent),
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            placeholderStyle: AppText.subtitle,
          ),
        ),
      ],
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(text, style: AppText.button),
      ),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
