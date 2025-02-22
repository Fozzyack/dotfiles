local db = require('dashboard')
db.setup({
theme = 'hyper',

config = {
  packages = { enable = true },

    header = {
  "                                                                                      ",
  "   ___ ___       __                           _______                  __             ",
  "  |   Y   .-----|  .----.-----.--------.----- |   _   .----.---.-.-----|__.-----.----.",
  "  |.  |   |  -__|  |  __|  _  |        |  -__ |.  1___|   _|  _  |__ --|  |  -__|   _|",
  "  |. / \\  |_____|__|____|_____|__|__|__|_____||.  __) |__| |___._|_____|__|_____|__|  ",
  "  |:      |                                   |:  |                                   ",
  "  |::.|:. |                                   |::.|                                   ",
  "  `--- ---'                                   `---'                                   ",
  },
  shortcut = {
    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
    {
      icon = ' ',
      icon_hl = '@variable',
      desc = 'Files',
      group = 'Label',
      action = 'Telescope find_files',
      key = 'f',
    },
    {
      desc = ' Apps',
      group = 'DiagnosticHint',
      action = 'Telescope app',
      key = 'a',
    },
    {
      desc = ' dotfiles',
      group = 'Number',
      action = 'Telescope dotfiles',
      key = 'd',
    },
  },
},
})
