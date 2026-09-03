import 'package:flutter/material.dart';
import 'package:rotina_comercial/theme.dart';
import 'package:rotina_comercial/types.dart';

class SpecialProductCard extends StatelessWidget {
  final SpecialItem item;
  final bool blocked;
  final void Function(SpecialItem) onUntreatedClick;
  final void Function(SpecialItem) onTreatedClick;

  const SpecialProductCard({
    super.key,
    required this.item,
    required this.blocked,
    required this.onUntreatedClick,
    required this.onTreatedClick,
  });

  @override
  Widget build(BuildContext context) {
    final treated = item.isTreated;

    final extraParts = ['Estoque: ${item.stockQuantity}'];
    if (item.daysWithoutSelling != null) {
      extraParts.add('Sem venda há ${item.daysWithoutSelling} dias');
    }

    return GestureDetector(
      onTap: () {
        if (blocked) return;
        if (treated) {
          onTreatedClick(item);
        } else {
          onUntreatedClick(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: treated
                ? AppColors.success.withOpacity(0.3)
                : blocked
                    ? const Color(0xFFD32F2F).withOpacity(0.3)
                    : const Color(0xFFC7C7C7),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Open Sans',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.ean} | ${item.sap}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                  Text(
                    extraParts.join(' | '),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: treated
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '✓ Tratado',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          fontFamily: 'Open Sans',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : blocked
                      ? Image.asset('assets/ic_block.png', width: 20, height: 20)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
