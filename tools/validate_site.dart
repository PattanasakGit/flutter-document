import 'dart:io';

final _attributePattern = RegExp(
  r'''(?:href|src)=["']([^"']+)["']''',
  caseSensitive: false,
);

void main() {
  final root = Directory.current;
  final htmlFiles = <File>[
    if (File('index.html').existsSync()) File('index.html'),
    ..._htmlFilesIn(Directory('chapters')),
    ..._htmlFilesIn(Directory('reference')),
  ];

  final errors = <String>[];
  if (htmlFiles.isEmpty) {
    stderr.writeln('No HTML files found.');
    exitCode = 1;
    return;
  }

  var localLinkCount = 0;
  for (final file in htmlFiles) {
    final source = file.readAsStringSync();
    final path = file.path;

    _require(
      source.toLowerCase().contains('<!doctype html>'),
      '$path: missing HTML5 doctype',
      errors,
    );
    _require(
      RegExp(r'''<html\s+[^>]*lang=["']th["']''', caseSensitive: false)
          .hasMatch(source),
      '$path: missing lang="th"',
      errors,
    );
    _require(
      RegExp(r'<title>\s*[^<]+\s*</title>', caseSensitive: false)
          .hasMatch(source),
      '$path: missing non-empty title',
      errors,
    );
    _require(
      source.contains('class="skip-link"'),
      '$path: missing skip link',
      errors,
    );
    _require(
      RegExp(r'<main(?:\s|>)', caseSensitive: false).allMatches(source).length ==
          1,
      '$path: requires exactly one main element',
      errors,
    );

    for (final match in _attributePattern.allMatches(source)) {
      final target = match.group(1)!;
      if (_isExternalResource(target)) {
        errors.add('$path: external resource is not offline-safe: $target');
        continue;
      }
      if (_isNonFileTarget(target)) continue;

      localLinkCount += 1;
      final cleanTarget = target.split('#').first.split('?').first;
      if (cleanTarget.isEmpty) continue;

      final resolved = File(
        Uri.file(file.absolute.path).resolve(cleanTarget).toFilePath(),
      );
      final directoryTarget = Directory(resolved.path);
      if (!resolved.existsSync() && !directoryTarget.existsSync()) {
        errors.add('$path: broken local link: $target');
      }
    }
  }

  final diagramPattern = RegExp(
    r'''<figure\s+[^>]*class=["'][^"']*\bdiagram\b[^"']*["'][^>]*>'''
    r'([\s\S]*?)</figure>',
    caseSensitive: false,
  );
  for (final file in htmlFiles) {
    final source = file.readAsStringSync();
    for (final match in diagramPattern.allMatches(source)) {
      final figure = match.group(1)!;
      final hasCaption =
          RegExp(r'<figcaption(?:\s|>)', caseSensitive: false).hasMatch(figure);
      final afterFigure = source.substring(match.end);
      final hasDescription = RegExp(
        r'''^\s*<p\s+[^>]*class=["'][^"']*\bdiagram-description\b''',
        caseSensitive: false,
      ).hasMatch(afterFigure);
      if (!hasCaption || !hasDescription) {
        errors.add(
          '${file.path}: Diagram requires figcaption and description',
        );
      }
    }
  }

  if (errors.isNotEmpty) {
    for (final error in errors) {
      stderr.writeln(error);
    }
    stderr.writeln(
      'Validation failed with ${errors.length} '
      '${errors.length == 1 ? 'error' : 'errors'}.',
    );
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Validated ${htmlFiles.length} HTML '
    '${htmlFiles.length == 1 ? 'file' : 'files'}; '
    '$localLinkCount local links resolved.',
  );
}

List<File> _htmlFilesIn(Directory directory) {
  if (!directory.existsSync()) return const [];
  final files = directory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.html'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  return files;
}

bool _isExternalResource(String target) {
  return target.startsWith('http://') ||
      target.startsWith('https://') ||
      target.startsWith('//');
}

bool _isNonFileTarget(String target) {
  return target.startsWith('#') ||
      target.startsWith('mailto:') ||
      target.startsWith('tel:') ||
      target.startsWith('data:') ||
      target.startsWith('javascript:');
}

void _require(bool condition, String message, List<String> errors) {
  if (!condition) errors.add(message);
}
