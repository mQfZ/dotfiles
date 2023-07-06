return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    
    use 'neovim/nvim-lspconfig'
    use 'nvim-treesitter/nvim-treesitter'

    use 'ray-x/lsp_signature.nvim'
    
    use {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons', opt = false }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = false }
    }

    use 'windwp/nvim-autopairs'
    use 'preservim/nerdcommenter'
    
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim', opt = false }
    }

    use 'morhetz/gruvbox'
    use 'joshdick/onedark.vim'
end)
