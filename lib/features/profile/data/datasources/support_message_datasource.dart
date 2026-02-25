import 'package:digital_wallett_system/features/profile/data/models/support_message_api_model.dart';
import 'package:digital_wallett_system/features/profile/domain/entities/support_message_entity.dart';

abstract interface class ISupportMessageLocalDatasource {
  Future<void> cacheMessages(List<SupportMessageEntity> list);
  List<SupportMessageEntity> getCachedMessages();
  Future<void> clearCache();
}

abstract interface class ISupportMessageRemoteDatasource {
  Future<List<SupportMessageApiModel>> getMessages();
  Future<SupportMessageApiModel> createMessage(String message);
  Future<SupportMessageApiModel> updateMessage(String id, String message);
  Future<void> deleteMessage(String id);
}
