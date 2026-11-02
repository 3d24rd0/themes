# Zelda 40th Anniversary Theme for Fish Shell
# Palette: Obsidian & Gold (Nintendo Switch OLED / Pro Controller Edition)

set -l foreground E6E2D8 normal
set -l selection 2C281E normal
set -l comment 5C605E brblack
set -l red C43F38 red
set -l orange DFB166 orange
set -l yellow E5CF77 yellow
set -l green 447A66 green
set -l blue 638BA4 blue
set -l teal 358075 cyan
set -l gold D4B260 yellow

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $teal
set -g fish_color_keyword $gold
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $blue
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $gold
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $gold
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
