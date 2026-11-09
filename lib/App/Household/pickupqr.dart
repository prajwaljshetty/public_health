import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dart:math';

// QR Code :
import 'package:qr_flutter/qr_flutter.dart';

// Theme :
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/Theme/theme.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

// Services
import 'package:public_health/Services/API/Household/api_service.dart';

class PickupQrPage extends StatefulWidget {
  const PickupQrPage({super.key});

  @override
  State<PickupQrPage> createState() => PickupQrPageState();
}

class PickupQrPageState extends State<PickupQrPage> {
  late String code;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    generateCode();
  }

  void generateCode() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final pickupRequestProvider = Provider.of<PickupRequestProvider>(
      context,
      listen: false,
    );

    code = (100000 + Random.secure().nextInt(900000)).toString();

    ApiService.registerCode(
      userprovider: userprovider,
      pickupRequestProvider: pickupRequestProvider,
      code: code,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userdata = Provider.of<UserProvider>(context, listen: false);
    final pickupdata = Provider.of<PickupRequestProvider>(
      context,
      listen: false,
    );

    final recipientName = userdata.username ?? l10n.householdRecipient;
    final id = pickupdata.pickupid ?? l10n.unavailableValue;
    final pickupTime = pickupdata.time != null
        ? DateFormat('dd MMM yyyy,hh:mm a')
              .format(DateTime.parse(pickupdata.time!))
        : l10n.notAvailableValue;
    final shortPickupId = id.length > 12 ? '${id.substring(0, 20)}...' : id;

    return AppScaffold(
      showBack: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Page heading
          Text(
            l10n.verifyYourPickup,
            style: AppText.title.copyWith(fontSize: 26, height: 1.2),
          ),

          const SizedBox(height: 18),
          if (_isLoading) ...[
            CupertinoActivityIndicator(),
          ] else ...[
            // 1. Request details receipt
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundwhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.requestDetails,
                      style: AppText.cardTitle.copyWith(fontSize: 16),
                    ),

                    const SizedBox(height: 12),

                    _detailItem(
                      label: l10n.recipientLabel,
                      value: recipientName,
                    ),

                    const SizedBox(height: 10),
                    const AppDashedDivider(),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.pickupIdLabel,
                            style: (AppText.cardSubtitle).copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundblack.withAlpha(10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    shortPickupId,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.cardSubtitle.copyWith(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  onPressed: id == l10n.unavailableValue
                                      ? null
                                      : () async {
                                          await Clipboard.setData(
                                            ClipboardData(text: id),
                                          );

                                          if (!context.mounted) return;

                                          showCupertinoDialog<void>(
                                            context: context,
                                            builder: (dialogContext) =>
                                                CupertinoAlertDialog(
                                                  content: Text(
                                                    l10n.pickupIdCopied,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            dialogContext,
                                                          ),
                                                      child: Text(
                                                        l10n.okButton,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                  child: const Icon(
                                    CupertinoIcons.doc_on_doc,
                                    size: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const AppDashedDivider(),
                    const SizedBox(height: 10),

                    _detailItem(
                      label: l10n.requestedTimeLabel,
                      value: pickupTime,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 2. QR ticket
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundwhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundwhite,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.pickupRequestedTitle,
                        style: AppText.cardTitle.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // QR code
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundwhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: id == l10n.unavailableValue
                            ? 'INVALID_PICKUP'
                            : code,
                        version: QrVersions.auto,
                        size: 170,
                        backgroundColor: AppColors.backgroundwhite,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),

                    GestureDetector(
                      onTap: id == l10n.unavailableValue
                          ? null
                          : () async {
                              await Clipboard.setData(ClipboardData(text: id));

                              if (!context.mounted) return;

                              showCupertinoDialog<void>(
                                context: context,
                                builder: (dialogContext) =>
                                    CupertinoAlertDialog(
                                      content: Text(l10n.pickupCodeCopied),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext),
                                          child: Text(l10n.okButton),
                                        ),
                                      ],
                                    ),
                              );
                            },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.layering,
                          borderRadius: BorderRadius.circular(16),
                          border: BoxBorder.all(width: 1),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          code.toString().split('').join('  '),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),

                    // Instructions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            CupertinoIcons.info_circle,
                            size: 19,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.pickupQrInstructions,
                              style: AppText.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailItem({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: (AppText.cardSubtitle).copyWith(color: AppColors.accent),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.label.copyWith(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }
}
