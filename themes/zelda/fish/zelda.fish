# Zelda Iconic Palette for Fish Shell
set -l foreground E8E4D8 normal
set -l selection 1A3536 normal
set -l comment 576975 brblack
set -l red E04747 red
set -l orange F5A623 orange
set -l yellow EAC448 yellow
set -l green 28C47B green
set -l blue 3B9EE0 blue
set -l teal 2EC4B6 cyan
set -l gold F5D35A yellow

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $teal
set -g fish_color_keyword $yellow
set -g fish_color_quote $green
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $blue
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $yellow
set -g fish_color_autosuggestion $comment
