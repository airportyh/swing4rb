require 'rubygems'
require 'swing4rb'
title = 'Alert'
message = 'Job Finished'
frame(title){|f|
  f.content_pane = border_panel(
    :center => label(message){|l| 
      l.horizontal_alignment = SwingConstants::CENTER
    },
    :south => flow_panel(button('Ok'){|b|
      b.add_action_listener {|e|
        java.lang.System.exit 0
      }
    })
  )
  f.pack
  f.size = dimension 300, 200
  f.center_on_screen
  f.visible = true
  f.default_close_operation = JFrame::EXIT_ON_CLOSE
}
