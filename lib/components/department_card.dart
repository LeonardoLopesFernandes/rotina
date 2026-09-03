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

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${department.department.code} - ${department.department.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (allTreated)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.check, color: Colors.white, size: 14),
                          ),
                        )
                      else if (blocked)
                        Image.asset('assets/ic_block.png', width: 22, height: 22),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => onViewAll(department),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 22, minHeight: 22),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$total',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
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
