import 'path_provider_stub.dart';

class PathProviderImpl implements PathProviderStub {
  @override
  Future<String> getApplicationSupportDirectory() => Future.value('');
}
