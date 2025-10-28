
import 'package:flutter/material.dart';

class CustomBottomItem {
  final String label;
  final IconData icon;
  const CustomBottomItem({required this.label, required this.icon});
}

class NavigationBottonbar extends StatefulWidget {
  final int pageIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomItem> items;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final double elevation;
  final Duration animationDuration;

  const NavigationBottonbar({
    super.key,
    required this.pageIndex,
    required this.onTap,
    required this.items,
    this.activeColor = Colors.deepPurple,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.elevation = 8,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<NavigationBottonbar> createState() => _NavigationBottonbarState();
}

class _NavigationBottonbarState extends State<NavigationBottonbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(33, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final isSelected = index == widget.pageIndex;

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    opacity: isSelected ? 0.0 : 1,
                    duration: widget.animationDuration,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: widget.activeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: widget.animationDuration,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? widget.activeColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? widget.activeColor
                            : widget.inactiveColor.withAlpha(0),
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected
                          ? widget.backgroundColor
                          : widget.activeColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
