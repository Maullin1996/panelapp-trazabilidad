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

@JS('File')
extension type _File._(JSObject _) implements JSObject {
  external factory _File(JSArray chunks, String filename, JSObject options);
}

@JS('document.createElement')
external JSObject _createElement(String tag);

@JS('navigator.canShare')
external bool _canShare(JSObject data);

@JS('navigator.share')
external JSObject _share(JSObject data);

extension on JSObject {
  external set href(String value);
  external void setAttribute(String name, String value);
  external void click();
}

Future<void> downloadPdfInBrowser(Uint8List bytes, String filename) async {
  try {
    final fileOptions = {'type': 'application/pdf'}.jsify() as JSObject;
    final file = _File([bytes.toJS].toJS, filename, fileOptions);
    final shareData =
        {
              'title': filename,
              'files': [file],
            }.jsify()
            as JSObject;

    if (_canShare(shareData)) {
      _share(shareData).dartify();
      return;
    }
  } catch (_) {
    // Si falla, cae al fallback de descarga
  }

  // Fallback: descarga directa (escritorio)
  final options = {'type': 'application/pdf'}.jsify() as JSObject;
  final blob = _Blob([bytes.toJS].toJS, options);
  final url = _createObjectURL(blob);
  final anchor = _createElement('a');
  anchor.href = url;
  anchor.setAttribute('download', filename);
  anchor.click();
  _revokeObjectURL(url);
}
