{
  programs.nixvim = {
    # suggested by nvim-ufo
    opts = {
      #foldlevel = 99; # minimum depth that will be folded by default
      #foldlevelstart = 99; # fold depth open when a new buffer is opened
    };

    # better folding by using LSP features
    plugins.nvim-ufo = {
      enable = false;

      #enableGetFoldVirtText = true;
      # from nvim-ufo docs: display no. of folded lines
      # foldVirtTextHandler = ''
      #   function(virtText, lnum, endLnum, width, truncate)
      #     local newVirtText = {}
      #     local suffix = (' … ↴ %d '):format(endLnum - lnum)
      #     local sufWidth = vim.fn.strdisplaywidth(suffix)
      #     local targetWidth = width - sufWidth
      #     local curWidth = 0
      #
      #     for _, chunk in ipairs(virtText) do
      #       local chunkText = chunk[1]
      #       local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      #
      #       if targetWidth > curWidth + chunkWidth then
      #         table.insert(newVirtText, chunk)
      #       else
      #         chunkText = truncate(chunkText, targetWidth - curWidth)
      #         local hlGroup = chunk[2]
      #         table.insert(newVirtText, {chunkText, hlGroup})
      #         chunkWidth = vim.fn.strdisplaywidth(chunkText)
      #
      #         -- str width returned from truncate() may less than 2nd argument, need padding
      #         if curWidth + chunkWidth < targetWidth then
      #           suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      #         end
      #         break
      #       end
      #
      #       curWidth = curWidth + chunkWidth
      #     end
      #
      #     table.insert(newVirtText, {suffix, 'MoreMsg'})
      #     return newVirtText
      #   end
      # '';
    };

    keymaps = [
      # built in commands change foldlevel, ufo commands don't
      # {
      #   action = "";
      #   key = "<leader>z";
      #   mode = "n";
      #   options = {
      #     desc = "+fold with UFO";
      #   };
      # }
      # {
      #   action = "<Cmd>Ufo openFoldsExceptKinds<CR>";
      #   key = "<leader>zr";
      #   mode = "n";
      #   options = {
      #     desc = "UFO: open folds one level";
      #   };
      # }
      # {
      #   action = "<Cmd>Ufo openAllFolds<CR>";
      #   key = "<leader>zR";
      #   mode = "n";
      #   options = {
      #     desc = "UFO: open all folds";
      #   };
      # }
      # {
      #   action = "<Cmd>Ufo closeFoldsWith<CR>";
      #   key = "<leader>zm";
      #   mode = "n";
      #   options = {
      #     desc = "UFO: close one level of folds";
      #   };
      # }
      # {
      #   action = "<Cmd>Ufo closeAllFolds<CR>";
      #   key = "<leader>zM";
      #   mode = "n";
      #   options = {
      #     desc = "UFO: close all folds";
      #   };
      # }
    ];
  };
}
