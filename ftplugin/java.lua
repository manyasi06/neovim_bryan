-- local jdtls = require('jdtls')
--

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
-- os.execute("mkdir " .. workspace_dir)
local jdtls_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local config_dir = jdtls_dir .. '/config_linux'
local plugin_dir = jdtls_dir .. '/plugins/'
local path_to_jar = plugin_dir .. 'org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  print("Missing root_dir")
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

 local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

 local config = {

     cmd = {
 	'java',
 	'-Declipse.application=org.eclipse.jdt.ls.core.id1',
     	'-Dosgi.bundles.defaultStartLevel=4',
     	'-Declipse.product=org.eclipse.jdt.ls.core.product',
     	'-Dlog.protocol=true',
     	'-Dlog.level=ALL',
     	'-Xms1g',
     	'--add-modules=ALL-SYSTEM',
     	'--add-opens', 'java.base/java.util=ALL-UNNAMED',
     	'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
 	'-jar', path_to_jar,
 	'-configuration', config_dir,
 	'-data', workspace_dir
     },
     root_dir = root_dir,
   -- capabilities = require("lsp.handlers").capabilities,
    contentProvider = { preferred = "fernflower" },
     settings = {
     java = {
       home = '/usr/lib/jvm/java-17-openjdk-amd64',
       eclipse = {
	 downloadSources = true,
       },
       maven = {
	 downloadSources = true,
	 updateSnapshots = true
       },
       implementationsCodeLens = {
        enabled = true,
       },
       referencesCodeLens = {
        enabled = true,
       },
       references = {
        includeDecompiledSources = true,
       },
       configuration = {
	updateBuildConfiguration = "interactive",
 	runtimes = {	
            {
              name = "JavaSE-17",
              path = "/usr/lib/jvm/java-17-openjdk-amd64",
            }
         }
       },
       signatureHelp = {
	 enabled = true
       },
       import = {
	 gradle = {
	   enabled = true
	 },
	 maven = {
	   enabled = true

	 }
       },
       codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            }
       },
       completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*"
            },
	     filteredTypes = {
          	"com.sun.*",
          	"io.micrometer.shaded.*",
          	"java.awt.*",
          	"jdk.*", "sun.*",
            },
          }
     }
   },
   capabilities = capabilities,
   flags = {
     allow_incremental_sync = true
   },
   init_options = {
     bundles = {},
     extendedClientCapabilities = extendedClientCapabilities
   },
 }

--function nnoremap(rhs, lhs, bufopts, desc)
--  bufopts.desc = desc
--  vim.keymap.set("n", rhs, lhs, bufopts)
--end
--
config['on_attach'] = function(client, bufnr)
  --require'keymaps'.map_java_keys(bufnr);
      require'lsp.handlers'.capabilities()
      require'jdtls.setup'.add_commands()
      require'jdtls'.setup_dap()
      require'lsp-status'.register_progress()
      require'compe'.setup {
          enabled = true;
          autocomplete = true;
          debug = false;
          min_length = 1;
          preselect = 'enable';
          throttle_time = 80;
          source_timeout = 200;
          incomplete_delay = 400;
          max_abbr_width = 100;
          max_kind_width = 100;
          max_menu_width = 100;
          documentation = true;

          source = {
            path = true;
            buffer = true;
            calc = true;
            vsnip = false;
            nvim_lsp = true;
            nvim_lua = true;
            spell = true;
            tags = true;
            snippets_nvim = false;
            treesitter = true;
          };
        }

     require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window_above_cur_line = false,
      padding = '',
      handler_opts = {
      border = "rounded"
       }
      }, bufnr)
      require'lspkind'.init()
      require'lspsaga'.init_lsp_saga()
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end  
  -- Regular Neovim LSP client keymappings
 -- nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
 -- nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
 -- nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
 -- nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
 -- nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
 -- nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
 -- nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
 -- nnoremap('<space>wl', function()
 --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
 -- end, bufopts, "List workspace folders")
 -- nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
 -- nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
 -- nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "Code actions")
 -- vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
 --   { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
 -- nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")

 -- -- Java extensions provided by jdtls
 -- nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
 -- nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
 -- nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
 -- vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
 --   { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
--end


-- config.handlers['$/progress'] = function() end
require('jdtls').start_or_attach(config)


