import 'dart:typed_data';
import 'dart:js_interop';

@JS('URL.createObjectURL')
external String _createObjectURL(JSObject blob);

@JS('URL.revokeObjectURL')
external void _revokeObjectURL(String url);

@JS('Blob')
extension type _Blob._(JSObject _) implements JSObject {
  external factory _Blob(JSArray chunks, JSObject options);
}

@JS('document.createElement')
external JSObject _createElement(String tag);

extension on JSObject {
  external set href(String value);
  external void setAttribute(String name, String value);
  external void click();
}

Future<void> downloadPdfInBrowser(Uint8List bytes, String filename) async {
  final options = {'type': 'application/pdf'}.jsify() as JSObject;
  final blob = _Blob([bytes.toJS].toJS, options);
  final url = _createObjectURL(blob);
  final anchor = _createElement('a');
  anchor.href = url;
  anchor.setAttribute('download', filename);
  anchor.click();
  _revokeObjectURL(url);
}
