// lib/widgets/custom_bottom_sheet.dart
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onClose;
  final Widget? action;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool isDismissible;
  final bool enableDrag;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const CustomBottomSheet({
    Key? key,
    required this.title,
    required this.children,
    this.onClose,
    this.action,
    this.initialChildSize = 0.9,
    this.minChildSize = 0.5,
    this.maxChildSize = 0.95,
    this.isDismissible = true,
    this.enableDrag = true,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius ?? const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildHeader(context),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              if (action != null) action!,
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    VoidCallback? onClose,
    Widget? action,
    double initialChildSize = 0.9,
    double minChildSize = 0.5,
    double maxChildSize = 0.95,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) {
          return CustomBottomSheet(
            title: title,
            children: children,
            onClose: onClose ?? () => Navigator.pop(context),
            action: action,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

// Example usage:
/*
// Simple usage
CustomBottomSheet.show(
  context: context,
  title: 'Bottom Sheet Title',
  children: [
    ListTile(
      title: Text('Item 1'),
      onTap: () {
        // Handle tap
        Navigator.pop(context);
      },
    ),
    ListTile(
      title: Text('Item 2'),
      onTap: () {
        // Handle tap
        Navigator.pop(context);
      },
    ),
  ],
);

// Advanced usage
CustomBottomSheet.show(
  context: context,
  title: 'Settings',
  action: IconButton(
    icon: Icon(Icons.save),
    onPressed: () {
      // Handle save
      Navigator.pop(context);
    },
  ),
  initialChildSize: 0.7,
  minChildSize: 0.4,
  maxChildSize: 0.9,
  backgroundColor: Theme.of(context).cardColor,
  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  children: [
    // Your settings widgets here
  ],
);

// With custom content
CustomBottomSheet.show(
  context: context,
  title: 'Custom Content',
  children: [
    Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heading',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Description text goes here. This can be a longer piece of content '
            'that explains something in detail.',
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle button press
              Navigator.pop(context);
            },
            child: Text('Action Button'),
          ),
        ],
      ),
    ),
  ],
);
*/