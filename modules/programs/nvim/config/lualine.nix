{ helpers, ... }:
{
  config = {
    plugins.lualine = {
      enable = true;
      sections.lualine_b = [
        {
          name = "macro-recording";
          fmt = ''
            function()
              local recording_register = vim.fn.reg_recording()
              if recording_register == "" then
                return ""
              else
                return "Recording @" .. recording_register
              end
            end
          '';
        }
        # TODO: make this actually refresh on some stuff
        {
          name = "better-escape";
          fmt = ''
            function()
              local ok, m = pcall(require, 'better_escape')
              return ok and m.waiting and '✺' or ""
            end
          '';
        }
      ];
    };

    autoCmd = [
      {
        event = "RecordingEnter";
        callback = helpers.mkRaw ''
          function()
            require('lualine').refresh({
              place = { "statusline" },
            })
          end
        '';
        desc = "Refresh lualine on recording";
      }
      {
        event = "RecordingLeave";
        callback = helpers.mkRaw ''
          function()
            -- This is going to seem really weird!
            -- Instead of just calling refresh we need to wait a moment because of the nature of
            -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
            -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
            -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
            -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
            local timer = vim.loop.new_timer()
            timer:start(
              50,
              0,
              vim.schedule_wrap(function()
                require('lualine').refresh({
                  place = { "statusline" },
                })
              end)
            )
          end
        '';
        desc = "Refresh lualine on recording";
      }
    ];
  };
}
