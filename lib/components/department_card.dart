import 'package:flutter/material.dart';
import 'package:rotina_comercial/components/product_card.dart';
import 'package:rotina_comercial/theme.dart';
import 'package:rotina_comercial/types.dart';

class DepartmentCard extends StatelessWidget {
  final Department department;
  final bool blocked;
  final void Function(Department) onViewAll;
  final void Function(Item) onEditItem;
  final void Function(Item) onShowBadge;

  const DepartmentCard({
    super.key,
    required this.department,
    required this.blocked,
    required this.onViewAll,
    required this.onEditItem,
    required this.onShowBadge,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = department.items
        .map((e) => e.copyWith(departmentCode: department.department.code))
        .toList();
    final total = allItems.length;
    final treatedCount = allItems.where((i) => i.treated).length;
    final allTreated = total > 0 && treatedCount == total;

    String? statusIcon;
    if (blocked) {
      statusIcon = 'assets/ic_block.png';
    } else if (allTreated) {
      statusIcon = 'assets/ic_check.png';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${department.department.code} - ${department.department.name}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                    if (statusIcon != null)
                      Image.asset(statusIcon, width: 18, height: 18),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => onViewAll(department),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x47000000),
                            blurRadius: 3.6,
                            offset: Offset(0, 1.6),
                          ),
                        ],
                      ),
                      child: const Text(
                        'VER TUDO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 20, minHeight: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '$total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: allItems
                .map((item) => ProductCard(
                      key: ValueKey('${item.id}-${item.ean}'),
                      item: item,
                      blocked: blocked,
                      onEdit: onEditItem,
                      onShowBadge: onShowBadge,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
