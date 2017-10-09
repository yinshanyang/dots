module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 12,
    fontFamily: 'FiraCode, "Fira Code", monospace',
    cursorColor: '#ebdbb2',
    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BLOCK',
    // set to true for blinking cursor
    cursorBlink: false,

    // color of the text
    foregroundColor: '#ebdbb2',
    backgroundColor: '#282828',
    borderColor: 'transparent',
    css: '',
    termCSS: '',

    // set to `true` (without backticks) if you're using a Linux setup that doesn't show native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: '',

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: 'false',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#282828',
      red: '#cc241d',
      green: '#98971a',
      yellow: '#d79921',
      blue: '#458588',
      magenta: '#b16286',
      cyan: '#689d6a',
      white: '#a89984',
      lightBlack: '#928374',
      lightRed: '#fb4934',
      lightGreen: '#b8bb26',
      lightYellow: '#fabd2f',
      lightBlue: '#83a598',
      lightMagenta: '#d3869b',
      lightCyan: '#8ec07c',
      lightWhite: '#ebdbb2'
    },

    shell: '',
    shellArgs: ['--login'],
    env: {},
    bell: 'SOUND',
    copyOnSelect: false

    // quickEdit: true
    // bellSoundURL: 'http://example.com/bell.mp3',
  },

  plugins: [
    'hyperminimal'
  ],
  localPlugins: [],

  keymaps: {
  }
};
