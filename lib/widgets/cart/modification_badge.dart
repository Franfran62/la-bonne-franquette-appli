import 'package:flutter/material.dart';

class ModificationBadge extends StatelessWidget {
  const ModificationBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("Modifié",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white)),
    );
  }
}
