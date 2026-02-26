import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool? isEmpty;
  final String emptyMessage;

  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.child,
    this.isEmpty,
    this.emptyMessage = "No data available",
  });

  @override
  State<ExpandableSectionWidget> createState() =>
      _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState
    extends State<ExpandableSectionWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final showEmpty =
        widget.isEmpty != null && widget.isEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF9144FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: showEmpty
              ? Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              widget.emptyMessage,
              style: const TextStyle(
                  color: Colors.white70),
            ),
          )
              : widget.child,
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
