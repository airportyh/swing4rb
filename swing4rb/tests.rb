#Copyright (c) 2007 Toby Ho
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
require 'swing4rb'

class App
  attr :card_panel
  attr_writer :card_panel
  attr :frame
  attr_writer :frame
end
  

def test_card_layout

    
  app = App.new
  
  app.frame = frame("Card Layout"){|f|
    f.content_pane = border_panel(
      :north => button("goodbye"){|b|
        b.add_action_listener {|event|
          app.card_panel.layout.show app.card_panel, b.text
          if b.text == 'hello'
            b.text = 'goodbye'
          else
            b.text = 'hello'
          end
        }
      },
      :center =>
        app.card_panel = card_panel(
        :hello => label('Hello World'),
        :goodbye => label('Goodbye')
      )
    )
    app.card_panel.layout.show(app.card_panel, 'hello')
    f.pack
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.visible = true
  }
end

def test_border_layout
  # ======= SAMPLE CODE ===============
  frame("Hello World") {|f|
    f.set_size 400, 400
      f.content_pane = border_panel(
      :north => flow_panel(
        button('click me'),
        button('no me')
    ),
      :center => scroll_pane(text_area('type here'))
    )
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.visible = true
  }
end

def test_flow_layout
  frame("flow layout"){|f|
    f.content_pane = flow_panel(
      text_field,
      button('click me')
    )
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_box_layout
  frame("Fill in the Form Please"){|f|
    f.content_pane = box_panel(:y_axis,
      box_panel(:x_axis, label('name'), text_field),
      box_panel(:x_axis, label('email'), text_field)
    )
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_grid_layout
  frame("grid layout"){|f|
    f.content_pane = grid_panel(3, 3){|p|
      (1..9).each{|n|
        p.add(button(n.to_s))
      }
    }
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_progress_bar
  frame("progress bar"){|f|
    f.content_pane = panel{|p|
      p.add(progress_bar(0, 5))
    }
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_mouse_listener
  app = {}
  frame("mouse listener"){|f|
    f.content_pane = border_panel(
      :north => (app[:text_area] = text_area),
      :center => panel{|pa|
        pa.add_mouse_listener(:clicked => proc {|event|
          app[:text_area].text = event.to_s
        })
      }
    )
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_key_listener
  app = {}
  frame("key listener"){|f|
    f.content_pane = border_panel(
      :north => (app[:label] = label),
      :center => panel
    )
    f.add_key_listener(:pressed => proc {|event|
          app[:label].text = event.to_s
        })
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_simplified_menu
  app = {}
  frame("menus"){|f|
    f.menubar {|bar|
      bar.menu('file'){|m|
        m.item('new', 'n'){|e| print 'new' }
        m.item('open', 'o'){|e| print 'open'}
        m.item('save', 's'){|e| print 'save'}
        m.item('exit', 'e'){|e| print 'exit'}
      }
      bar.menu('edit'){|m|
        m.item('undo', 'u'){|e| print 'undo'}
        m.insertSeparator 1
        m.item('cut', 'x'){|e| print 'cut'}
        m.item('copy', 'x'){|e| print 'copy'}
        m.item('paste', 'v'){|e| print 'paste'}
      }
      bar.menu('other'){|m|
        m.submenu('submenu1'){|sm|
          sm.item('extra1', 'x'){|e| print 'extra1' }
          sm.submenu('submenu2'){|ssm|
            ssm.item('extra2', 'y'){|e| print 'extra2'}
          }
        }
        m.check_box_item('check me'){|e| print 'check me'}
        m.radio_button_item('radio1'){|e| print 'radio1'}
        m.radio_button_item('radio2'){|e| print 'radio2'}
        m.item('potted plant'){|e| print 'potted plant'}
      }
    }
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_toolbar
  app = {}
  frame('toolbar'){|f|
    f.content_pane = border_panel(:page_start => 
        tool_bar('toolbar', (JToolBar::HORIZONTAL)){|bar|
          bar.add(button('hello'))
          bar.add(button('hey'))
        },
      :center => scroll_pane(text_area)
    )
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

def test_border
  app = {}
  frame('border'){|f|
    f.content_pane = panel{|p|
      p.border = line_border((Color::BLACK), 4)
      p.add(button('click me'))
    }
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end


def test_border_2
  app = {}
  frame('border'){|f|
    f.content_pane = panel{|p|
      p.border = titled_border('hello world')
      p.add(button('click me'))
    }
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.pack
    f.visible = true
  }
end

class App2
  def initialize
    @frame = frame("Card Layout"){|f|
      f.content_pane = border_panel(
        :north => button("goodbye"){|b|
          b.add_action_listener {|event|
            @card_panel.layout.show @card_panel, b.text
            if b.text == 'hello'
              b.text = 'goodbye'
            else
              b.text = 'hello'
            end
          }
        },
        :center =>
          @card_panel = card_panel(
          :hello => label('Hello World'),
          :goodbye => label('Goodbye')
        )
      )
      @card_panel.layout.show(@card_panel, 'hello')
      f.pack
      f.default_close_operation = JFrame::EXIT_ON_CLOSE
      f.visible = true
    }
  end 
end

def test_app2
  app = App2.new
end

def test_list
  app = {}
  frame('list'){|f|
    f.content_pane = border_panel(:center => 
      scroll_pane(app['list'] = list(['one', 'two'].to_java){|l|
        l.add_list_selection_listener {|event|
          print app['list'].selected_value
          print event
        }
      })
    )
    f.pack
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.visible = true
  }
end

def test_combo_box
  app = {}
  frame('combobox'){|f|
    f.content_pane = border_panel(:center =>
      app['combo'] = combo_box(['one', 'two'].to_java){|cb|
        cb.add_action_listener {|l|
          print app['combo'].selected_item
        }
      }
    )
    f.pack
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.visible = true
  }
end
def test_tabbed_pane
  frame('tabbed_pane'){|f|
    f.content_pane = border_panel(
      :center => tabbed_pane(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT) {|tp|
        tp.add 'hello', button('hello')
        
      }
    )
    f.pack
    f.default_close_operation = JFrame::EXIT_ON_CLOSE
    f.visible = true
  }
end

def all
  test_border_layout
  test_flow_layout
  test_box_layout
  test_grid_layout
  test_card_layout
  test_progress_bar
  test_mouse_listener
  test_key_listener
  test_simplified_menu
  test_toolbar
  test_border_2
  test_app2
  test_list
  test_combo_box
  test_tabbed_pane
end
all