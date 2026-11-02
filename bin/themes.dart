import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

final String homeDir = Platform.environment['HOME'] ?? '';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('apply')
    ..addCommand('list');

  final applyParser = parser.commands['apply']!
    ..addFlag('all', abbr: 'a', defaultsTo: true, help: 'Apply to all supported targets')
    ..addFlag('ghostty', help: 'Apply to Ghostty terminal')
    ..addFlag('tmux', help: 'Apply to tmux status bar and window styling')
    ..addFlag('gentle-shell', help: 'Apply to Gentle Shell / Pi')
    ..addFlag('fish', help: 'Apply to Fish shell syntax highlighting')
    ..addFlag('starship', help: 'Apply to Starship prompt')
    ..addFlag('vscode', help: 'Apply to VS Code colorCustomizations')
    ..addFlag('obsidian', help: 'Apply to Obsidian CSS snippet (Grimorio)')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage help');

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } catch (e) {
    print('Error: $e\n');
    _printUsage(parser);
    exit(1);
  }

  if (results.command == null || results.command!.name == 'list') {
    _listThemes();
    return;
  }

  if (results.command!.name == 'apply') {
    final applyResults = results.command!;
    if (applyResults['help'] as bool || applyResults.rest.isEmpty) {
      print('Usage: dart run bin/themes.dart apply <theme-name> [options]\n');
      print(applyParser.usage);
      exit(0);
    }

    final themeName = applyResults.rest.first;
    _applyTheme(themeName, applyResults);
  }
}

void _printUsage(ArgParser parser) {
  print('=== Themes CLI (Dart) ===');
  print('Usage:');
  print('  dart run bin/themes.dart list');
  print('  dart run bin/themes.dart apply <theme-name> [--target]\n');
  print('Available commands:');
  print('  list   List all available themes in this repository');
  print('  apply  Apply a theme to your tools (Ghostty, tmux, Gentle Shell, Fish, Starship, VS Code, Obsidian)');
}

String _getThemesRoot() {
  final scriptDir = p.dirname(Platform.script.toFilePath());
  // If running from repo root or bin/:
  if (p.basename(scriptDir) == 'bin') {
    return p.join(p.dirname(scriptDir), 'themes');
  }
  return p.join(Directory.current.path, 'themes');
}

void _listThemes() {
  final themesDir = Directory(_getThemesRoot());
  if (!themesDir.existsSync()) {
    print('Error: Themes directory not found at ${themesDir.path}');
    exit(1);
  }

  print('\n🎨 Available Themes:');
  print('──────────────────────────────────────────────────────────');
  for (final entity in themesDir.listSync()) {
    if (entity is Directory) {
      final name = p.basename(entity.path);
      final readme = File(p.join(entity.path, 'README.md'));
      var desc = '';
      if (readme.existsSync()) {
        final lines = readme.readAsLinesSync();
        if (lines.length > 2) {
          desc = lines[2].replaceAll('#', '').trim();
        }
      }
      print('  • \x1B[1m$name\x1B[0m ${desc.isNotEmpty ? "- $desc" : ""}');
    }
  }
  print('──────────────────────────────────────────────────────────');
  print('Run "dart run bin/themes.dart apply <theme-name>" to install.\n');
}

void _applyTheme(String themeName, ArgResults options) {
  final themeDir = Directory(p.join(_getThemesRoot(), themeName));
  if (!themeDir.existsSync()) {
    print('❌ Error: Theme "$themeName" does not exist in ${_getThemesRoot()}.');
    print('Run "dart run bin/themes.dart list" to see available themes.');
    exit(1);
  }

  print('\n🚀 Applying theme "\x1B[1m$themeName\x1B[0m"...');

  final specificTarget = options['ghostty'] as bool ||
      options['tmux'] as bool ||
      options['gentle-shell'] as bool ||
      options['fish'] as bool ||
      options['starship'] as bool ||
      options['vscode'] as bool ||
      options['obsidian'] as bool;

  final applyAll = !specificTarget;

  if (applyAll || options['ghostty'] as bool) _applyGhostty(themeName, themeDir);
  if (applyAll || options['tmux'] as bool) _applyTmux(themeName, themeDir);
  if (applyAll || options['gentle-shell'] as bool) _applyGentleShell(themeName, themeDir);
  if (applyAll || options['fish'] as bool) _applyFish(themeName, themeDir);
  if (applyAll || options['starship'] as bool) _applyStarship(themeName, themeDir);
  if (applyAll || options['vscode'] as bool) _applyVSCode(themeName, themeDir);
  if (applyAll || options['obsidian'] as bool) _applyObsidian(themeName, themeDir);

  print('\n✨ Theme "$themeName" applied successfully!\n');
}

void _applyGhostty(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'ghostty', themeName));
  if (!source.existsSync()) return;

  final targetDir = Directory(p.join(homeDir, '.config', 'ghostty', 'themes'));
  targetDir.createSync(recursive: true);
  final target = File(p.join(targetDir.path, themeName));
  source.copySync(target.path);

  // Update theme directive in ~/.config/ghostty/config
  final configFile = File(p.join(homeDir, '.config', 'ghostty', 'config'));
  if (configFile.existsSync()) {
    var content = configFile.readAsStringSync();
    if (content.contains(RegExp(r'^theme\s*=', multiLine: true))) {
      content = content.replaceAll(RegExp(r'^theme\s*=.*$', multiLine: true), 'theme = $themeName');
    } else {
      content += '\ntheme = $themeName\n';
    }
    configFile.writeAsStringSync(content);
  }
  print('  ✓ Ghostty: theme installed and configured in ~/.config/ghostty/config (Reload: Cmd+Shift+,)');
}

void _applyTmux(String themeName, Directory themeDir) {
  final palSource = File(p.join(themeDir.path, 'tmux', 'palette.sh'));
  final defSource = File(p.join(themeDir.path, 'tmux', 'default.sh'));
  if (!palSource.existsSync() || !defSource.existsSync()) return;

  final targetDir = Directory(p.join(homeDir, '.tmux', 'plugins', 'tmux-kanagawa', 'themes', 'gotham'));
  if (targetDir.existsSync()) {
    palSource.copySync(p.join(targetDir.path, 'palette.sh'));
    defSource.copySync(p.join(targetDir.path, 'default.sh'));

    try {
      Process.runSync('tmux', ['source-file', p.join(homeDir, '.tmux.conf')]);
      final ukiyoScript = p.join(homeDir, '.tmux', 'plugins', 'tmux-kanagawa', 'ukiyo.tmux');
      if (File(ukiyoScript).existsSync()) {
        Process.runSync(ukiyoScript, []);
      }
      print('  ✓ tmux: status bar reloaded in hot session');
    } catch (_) {
      print('  ✓ tmux: palette files updated (run "tmux source-file ~/.tmux.conf" to reload)');
    }
  }
}

void _applyGentleShell(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'gentle-shell', 'Zelda-40th.json'));
  if (!source.existsSync()) return;

  final targetThemeFile = p.join(homeDir, '.gentle-shell', 'agent', 'themes', 'Zelda-40th.json');
  File(targetThemeFile).parent.createSync(recursive: true);
  source.copySync(targetThemeFile);

  final settingsFile = File(p.join(homeDir, '.gentle-shell', 'agent', 'settings.json'));
  if (settingsFile.existsSync()) {
    var content = settingsFile.readAsStringSync();
    content = content.replaceAll(RegExp(r'"theme":\s*"[^"]*"'), '"theme": "Zelda-40th"');
    settingsFile.writeAsStringSync(content);
  }
  print('  ✓ Gentle Shell: theme updated in ~/.gentle-shell/agent/settings.json (Reload: /reload)');
}

void _applyFish(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'fish', '$themeName.fish'));
  if (!source.existsSync()) return;

  final targetDir = Directory(p.join(homeDir, '.config', 'fish', 'conf.d'));
  targetDir.createSync(recursive: true);
  final target = File(p.join(targetDir.path, '$themeName.fish'));
  source.copySync(target.path);
  print('  ✓ Fish: snippet copied to ~/.config/fish/conf.d/$themeName.fish');
}

void _applyStarship(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'starship', 'starship-$themeName.toml'));
  if (!source.existsSync()) return;

  print('  ✓ Starship: palette snippet available at ${source.path}');
}

void _applyVSCode(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'vscode', 'settings.json'));
  if (!source.existsSync()) return;

  final vsCodeSettings = File(p.join(homeDir, 'Library', 'Application Support', 'Code', 'User', 'settings.json'));
  if (vsCodeSettings.existsSync()) {
    print('  ✓ VS Code: color customizations documented at ${source.path}');
  }
}

void _applyObsidian(String themeName, Directory themeDir) {
  final source = File(p.join(themeDir.path, 'obsidian', '$themeName.css'));
  if (!source.existsSync()) return;

  // Check common Obsidian vaults (e.g. Grimorio)
  final vaults = [
    Directory(p.join(homeDir, 'secretario', '.obsidian', 'snippets')),
    Directory(p.join(homeDir, 'Grimorio', '.obsidian', 'snippets')),
    Directory(p.join(homeDir, 'Documents', 'Grimorio', '.obsidian', 'snippets')),
  ];

  var installed = false;
  for (final vaultSnippets in vaults) {
    if (vaultSnippets.parent.existsSync()) {
      vaultSnippets.createSync(recursive: true);
      source.copySync(p.join(vaultSnippets.path, '$themeName.css'));
      print('  ✓ Obsidian: snippet installed to ${vaultSnippets.path}/$themeName.css');
      installed = true;
    }
  }

  if (!installed) {
    print('  ✓ Obsidian: CSS snippet ready at ${source.path}');
  }
}
