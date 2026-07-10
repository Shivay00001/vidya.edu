import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    required String text,
    required MessageRole role,
    required DateTime timestamp,
    List<MessageAttachmentModel>? attachments,
    @Default(false) bool isStreaming,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}

@freezed
abstract class MessageAttachmentModel with _$MessageAttachmentModel {
  const factory MessageAttachmentModel({
    required String id,
    required String type,
    required String url,
    String? thumbnail,
  }) = _MessageAttachmentModel;

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentModelFromJson(json);
}

extension ChatMessageModelX on ChatMessageModel {
  ChatMessage toEntity() => ChatMessage(
        id: this.id,
        text: this.text,
        role: this.role,
        timestamp: this.timestamp,
        attachments: this.attachments?.map((e) => e.toEntity()).toList(),
        isStreaming: this.isStreaming,
      );
}

extension MessageAttachmentModelX on MessageAttachmentModel {
  MessageAttachment toEntity() => MessageAttachment(
        id: id,
        type: type,
        url: url,
        thumbnail: thumbnail,
      );
}


