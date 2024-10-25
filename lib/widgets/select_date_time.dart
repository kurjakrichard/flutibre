import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import 'common_text_field.dart';

class SelectDateTime extends ConsumerWidget {
  const SelectDateTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);

    return CommonTextField(
      title: 'Date',
      hintText: Helpers.dateFormatter(date),
      readOnly: true,
      suffixIcon: IconButton(
        onPressed: () => Helpers.selectDate(context, ref),
        icon: const FaIcon(FontAwesomeIcons.calendar),
      ),
    );
  }
}
