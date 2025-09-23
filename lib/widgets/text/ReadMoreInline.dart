import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/theme/theme.dart';
// import 'package:travel_submission_beginner_flutter_dicoding/themes/constant.dart';

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
    final defaultTextStyle =
        widget.style ??
        const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'SFUIDisplay',
        );

    if (isExpanded) {
      return Text.rich(
        TextSpan(
          text: widget.text,
          style: defaultTextStyle,
          children: [
            TextSpan(
              text: ' Read Less',
              style:
                  widget.moreStyle ??
                  TextStyle(
                    color: colorPrimary, // konsisten dengan constant.dart
                    fontWeight: FontWeight.w500,
                  ),
              recognizer: _toggleRecognizer,
            ),
          ],
        ),
      );
    }

    // Collapsed state
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: defaultTextStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: defaultTextStyle);
        }

        // Potong teks agar muat + tambahkan "Read More"
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
                style:
                    widget.moreStyle ??
                    TextStyle(
                      color: colorPrimary, // konsisten dengan constant.dart
                      fontWeight: FontWeight.w500,
                    ),
                recognizer: _toggleRecognizer,
              ),
            ],
          ),
        );
      },
    );
  }
}
