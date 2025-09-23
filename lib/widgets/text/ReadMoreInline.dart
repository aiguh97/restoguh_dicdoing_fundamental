import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/style/colors/restoguh_colors.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';

class ReadMoreInline extends StatefulWidget {
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
  State<ReadMoreInline> createState() => _ReadMoreInlineState();
}

class _ReadMoreInlineState extends State<ReadMoreInline> {
  bool isExpanded = false;
  late final TapGestureRecognizer _toggleRecognizer;

  @override
  void initState() {
    super.initState();
    _toggleRecognizer = TapGestureRecognizer()
      ..onTap = () => setState(() => isExpanded = !isExpanded);
  }

  @override
  void dispose() {
    _toggleRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = widget.style ?? RestoguhTextStyles.readMore;
    final moreTextStyle =
        widget.moreStyle ??
        RestoguhTextStyles.readMoreMore.copyWith(
          color: RestoguhColors.blue.primaryColor,
        );

    if (isExpanded) {
      return Text.rich(
        TextSpan(
          text: widget.text,
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
        final span = TextSpan(text: widget.text, style: defaultTextStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
          ellipsis: '…',
        )..layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: defaultTextStyle);
        }

        // Cari posisi pemotongan teks agar muat
        final cutoff = tp.getPositionForOffset(
          Offset(tp.width, tp.preferredLineHeight * widget.trimLines),
        );
        final endIndex = cutoff.offset.clamp(0, widget.text.length);

        return Text.rich(
          TextSpan(
            text: '${widget.text.substring(0, endIndex).trimRight()}… ',
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
  }
}
