import 'package:path_provider/path_provider.dart' as path_provider;
import 'path_provider_stub.dart';

class PathProviderImpl implements PathProviderStub {
  @override
  Future<String> getApplicationSupportDirectory() =>
      path_provider.getApplicationSupportDirectory().then((dir) => dir.path);
}
