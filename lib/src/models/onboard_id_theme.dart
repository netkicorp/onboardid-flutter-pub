import 'id_type.dart';
import 'picture_type.dart';

class OnBoardIdTheme {
  final ButtonColors buttons;
  final ContentColors content;
  final List<InstructionContent> instructions;

  const OnBoardIdTheme({
    this.buttons = const ButtonColors(),
    this.content = const ContentColors(),
    this.instructions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'buttons': buttons.toMap(),
      'content': content.toMap(),
      'instructions': instructions.map((e) => e.toMap()).toList(),
    };
  }
}

class ButtonColors {
  final String? primaryBackground;
  final String? primaryText;
  final String? secondaryBackground;
  final String? secondaryText;
  final double? cornerRadiusDp;

  const ButtonColors({
    this.primaryBackground,
    this.primaryText,
    this.secondaryBackground,
    this.secondaryText,
    this.cornerRadiusDp,
  });

  Map<String, dynamic> toMap() {
    return {
      'primaryBackground': primaryBackground,
      'primaryText': primaryText,
      'secondaryBackground': secondaryBackground,
      'secondaryText': secondaryText,
      'cornerRadiusDp': cornerRadiusDp,
    };
  }
}

class ContentColors {
  final String? background;
  final String? surface;
  final String? border;
  final String? titleText;
  final String? subtitleText;
  final String? bodyText;

  const ContentColors({
    this.background,
    this.surface,
    this.border,
    this.titleText,
    this.subtitleText,
    this.bodyText,
  });

  Map<String, dynamic> toMap() {
    return {
      'background': background,
      'surface': surface,
      'border': border,
      'titleText': titleText,
      'subtitleText': subtitleText,
      'bodyText': bodyText,
    };
  }
}

class InstructionContent {
  final IdType idType;
  final PictureType pictureType;
  final String? title;
  final String? subtitle;
  final String? body;
  final List<InstructionItem>? steps;
  final String? imageUrl;
  final String? videoPath;

  const InstructionContent({
    required this.idType,
    required this.pictureType,
    this.title,
    this.subtitle,
    this.body,
    this.steps,
    this.imageUrl,
    this.videoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'idType': idType.value,
      'pictureType': pictureType.value,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'steps': steps?.map((e) => e.toMap()).toList(),
      'imageUrl': imageUrl,
      'videoPath': videoPath,
    };
  }
}

class InstructionItem {
  final String text;
  final String? iconUrl;
  final bool isWarning;

  const InstructionItem({
    required this.text,
    this.iconUrl,
    this.isWarning = false,
  });

  Map<String, dynamic> toMap() {
    return {'text': text, 'iconUrl': iconUrl, 'isWarning': isWarning};
  }
}
