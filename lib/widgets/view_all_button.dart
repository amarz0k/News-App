import 'package:flutter/material.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/l10n/app_localizations.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
              color: Colors.grey,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: AppStyle.white16Bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Center(child: Icon(Icons.arrow_forward_ios_rounded)),
          ),
        ],
      ),
    );
  }
}
