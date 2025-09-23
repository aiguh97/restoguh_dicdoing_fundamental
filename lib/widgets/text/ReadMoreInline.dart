import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/read_more_provider.dart';
import 'package:restoguh_dicoding_fundamentl/style/colors/restoguh_colors.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';

class ReadMoreInline extends StatelessWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final TextStyle? moreStyle;

  const ReadMoreInline({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.style,
    this.moreStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = style ?? RestoguhTextStyles.readMore;
    final moreTextStyle =
        moreStyle ??
        RestoguhTextStyles.readMoreMore.copyWith(
          color: RestoguhColors.blue.primaryColor,
        );

    return ChangeNotifierProvider(
      create: (_) => ReadMoreProvider(),
      child: Consumer<ReadMoreProvider>(
        builder: (context, provider, child) {
          final _toggleRecognizer = TapGestureRecognizer()
            ..onTap = provider.toggle;

          if (provider.isExpanded) {
            return Text.rich(
              TextSpan(
                text: text,
                style: defaultTextStyle,
                children: [
                  TextSpan(
                    text: ' Read Less',
                    style: moreTextStyle,
                    recognizer: _toggleRecognizer,
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final span = TextSpan(text: text, style: defaultTextStyle);
              final tp = TextPainter(
                text: span,
                maxLines: trimLines,
                textDirection: TextDirection.ltr,
                ellipsis: '…',
              )..layout(maxWidth: constraints.maxWidth);

              if (!tp.didExceedMaxLines) {
                return Text(text, style: defaultTextStyle);
              }

              final cutoff = tp.getPositionForOffset(
                Offset(tp.width, tp.preferredLineHeight * trimLines),
              );
              final endIndex = cutoff.offset.clamp(0, text.length);

              return Text.rich(
                TextSpan(
                  text: '${text.substring(0, endIndex).trimRight()}… ',
                  style: defaultTextStyle,
                  children: [
                    TextSpan(
                      text: 'Read More',
                      style: moreTextStyle,
                      recognizer: _toggleRecognizer,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
