return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets',
        { 'L3MON4D3/LuaSnip', version = 'v2.*', run = "make install_jsregexp" },
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
}

