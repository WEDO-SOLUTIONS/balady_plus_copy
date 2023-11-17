import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IwishTextEditingField extends StatefulWidget {
  final void Function(String) onChanged;
  final String? initialValue;

  const IwishTextEditingField({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<IwishTextEditingField> createState() => _IwishTextEditingFieldState();
}

class _IwishTextEditingFieldState extends State<IwishTextEditingField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 11,
      maxLines: 11,
      controller: _controller,
      style: GoogleFonts.inter(
        color: const Color(0xFF1D2A36),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: const Color(0xff4CA5B4),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF4F4F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }
}
