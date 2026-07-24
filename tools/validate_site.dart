import 'dart:io';

final _attributePattern = RegExp(
  r'''(?:href|src)=["']([^"']+)["']''',
  caseSensitive: false,
);

final _sourcePathPattern = RegExp(
  r'\b(?:lib|test)/[a-zA-Z0-9_./-]+\.dart\b',
);

final _releaseCommandPattern = RegExp(
  r'flutter build (?:apk|appbundle|ios|ipa|web)'
  r'[\s\S]*?(?=flutter build |</code>)',
);

const _expectedPages = <String>{
  'index.html',
  'chapters/01-orientation.html',
  'chapters/02-react-to-flutter.html',
  'chapters/03-macos-toolchain.html',
  'chapters/04-clone-and-run.html',
  'chapters/05-dart-types.html',
  'chapters/06-null-collections-patterns.html',
  'chapters/07-functions-classes-generics.html',
  'chapters/08-async-errors-results.html',
  'chapters/09-widget-runtime.html',
  'chapters/10-layout-theme-forms.html',
  'chapters/11-state-lifecycle.html',
  'chapters/12-boilerplate-map.html',
  'chapters/13-riverpod.html',
  'chapters/14-go-router.html',
  'chapters/15-network-storage-errors.html',
  'chapters/16-task-domain.html',
  'chapters/17-offline-repository.html',
  'chapters/18-task-riverpod.html',
  'chapters/19-task-form.html',
  'chapters/20-task-mutations.html',
  'chapters/21-dio-datasource.html',
  'chapters/22-capstone-integration.html',
  'chapters/23-testing.html',
  'chapters/24-debug-performance.html',
  'chapters/25-production-concerns.html',
  'chapters/26-build-release.html',
  'chapters/27-production-checklist.html',
  'chapters/28-ai-workflow.html',
  'reference/commands.html',
  'reference/glossary.html',
  'reference/architecture-decisions.html',
  'reference/troubleshooting.html',
};

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

  for (final expectedPage in _expectedPages) {
    if (!File(expectedPage).existsSync()) {
      errors.add('Missing required page: $expectedPage');
    }
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
      RegExp(
        r'''<html\s+[^>]*lang=["']th["']''',
        caseSensitive: false,
      ).hasMatch(source),
      '$path: missing lang="th"',
      errors,
    );
    _require(
      RegExp(
        r'<title>\s*[^<]+\s*</title>',
        caseSensitive: false,
      ).hasMatch(source),
      '$path: missing non-empty title',
      errors,
    );
    _require(
      source.contains('class="skip-link"'),
      '$path: missing skip link',
      errors,
    );
    _require(
      RegExp(
            r'<main(?:\s|>)',
            caseSensitive: false,
          ).allMatches(source).length ==
          1,
      '$path: requires exactly one main element',
      errors,
    );
    final catalogScriptIndex = source.indexOf('assets/js/catalog.js');
    final siteScriptIndex = source.indexOf('assets/js/site.js');
    _require(
      catalogScriptIndex != -1 &&
          siteScriptIndex != -1 &&
          catalogScriptIndex < siteScriptIndex,
      '$path: catalog.js must load before site.js',
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
      final resolved = cleanTarget.isEmpty
          ? file
          : File(
              Uri.file(file.absolute.path).resolve(cleanTarget).toFilePath(),
            );
      final directoryTarget = Directory(resolved.path);
      if (!resolved.existsSync() && !directoryTarget.existsSync()) {
        errors.add('$path: broken local link: $target');
        continue;
      }

      final fragment = _fragmentOf(target);
      if (fragment != null &&
          fragment.isNotEmpty &&
          resolved.path.endsWith('.html') &&
          !_containsFragment(resolved, fragment)) {
        errors.add('$path: missing fragment "#$fragment" in $cleanTarget');
      }
    }

    for (final match in _sourcePathPattern.allMatches(source)) {
      final sourcePath = match.group(0)!;
      final referencedFile = File(
        'example/task_management_app/$sourcePath',
      );
      if (!referencedFile.existsSync()) {
        errors.add('$path: missing referenced example source: $sourcePath');
      }
    }

    for (final match in _releaseCommandPattern.allMatches(source)) {
      final command = match.group(0)!;
      if (!command.contains('lib/main_production.dart')) {
        errors.add(
          '$path: release command must target lib/main_production.dart',
        );
      }
    }
    if (source.contains('dart-define=APP_ENV')) {
      errors.add('$path: APP_ENV is not a supported entrypoint selector');
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
      final hasCaption = RegExp(
        r'<figcaption(?:\s|>)',
        caseSensitive: false,
      ).hasMatch(figure);
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
  final files =
      directory
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
  return target.startsWith('mailto:') ||
      target.startsWith('tel:') ||
      target.startsWith('data:') ||
      target.startsWith('javascript:');
}

String? _fragmentOf(String target) {
  final index = target.indexOf('#');
  if (index == -1) return null;
  return Uri.decodeComponent(target.substring(index + 1));
}

bool _containsFragment(File file, String fragment) {
  final escaped = RegExp.escape(fragment);
  return RegExp(
    '''(?:id|name)=["']$escaped["']''',
    caseSensitive: false,
  ).hasMatch(file.readAsStringSync());
}

void _require(bool condition, String message, List<String> errors) {
  if (!condition) errors.add(message);
}
