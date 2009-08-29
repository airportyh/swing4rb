require 'rubygems'
require 'swing4rb'


import javax.swing.ListCellRenderer
import java.awt.Toolkit
import javax.swing.ScrollPaneConstants
import javax.swing.border.BevelBorder

class ContactListCellRenderer
  include ListCellRenderer # this is how you implement a Java interface
  def initialize
    @label = label(image_icon('pixmaps/status/16/available.png')){|lb|
      lb.opaque = true
      lb.horizontal_alignment = SwingConstants::LEFT
      lb.icon_text_gap = 10
      lb.border = empty_border(5, 10, 5, 10)
    }
  end
          
  def getListCellRendererComponent(list, value, index, selected, focused)
    if selected then
      @label.foreground = list.selection_foreground
      @label.background = list.selection_background
    else
      @label.foreground = list.foreground
      @label.background = list.background
    end
    @label.text = value
    @label
  end
end

class StatusButtonCellRenderer
  include ListCellRenderer
  def initialize
    @label = label(image_icon('pixmaps/status/16/available.png')){|lb|
      lb.opaque = true
      lb.horizontal_alignment = SwingConstants::LEFT
      lb.icon_text_gap = 10
      lb.border = empty_border(5, 10, 5, 10)
    }
  end
  
  def getListCellRendererComponent(list, value, index, selected, focused)
    if selected then
      @label.foreground = list.selection_foreground
      @label.background = list.selection_background
    else
      @label.foreground = list.foreground
      @label.background = list.background
    end
    @label.text = value
    @label
  end
end

setup_grid_bag_constraints({
  :status_combo => gbc{|g|
    g.gridx = 0
    g.gridy = 0
    g.insets = insets(5,5,5,5)
    g.fill = GridBagConstraints::BOTH
    g.weightx = 1.0
  },
  :display_icon => gbc{|g|
    g.gridx = 1
    g.gridy = 0
    g.insets = insets(5,5,5,5)
    g.fill = GridBagConstraints::NONE
    g.weightx = 0.0
  }
})

class App
  def initialize
    @buddies = ['Cooper', 'BlarEvil', 'cantonairport', 'drewlper', 'grmei', 'Future AtWork', 
      'James', 'koon', 'maodean', 'felixmayer', 'Mindy', 'r5ears']
    @accounts = ['cantonairport', '22764563', 'airportyh@hotmail.com']
    @statuses = ['Available', 'Away', 'Invisible', 'Offline', "I'm not here right now", 'New...', 'Saved...']
    @frame = frame('Buddy List'){|f|
      f.menubar {|bar|
        bar.menu('Buddies'){|m|
          m.item('New Instant Message...', 'm')
          m.item('Join a Chat...', 'c')
          m.item('Get User Info...', 'i')
          m.item('View User Log...', 'l')
          m.separator
          m.cb_item('Show Offline Buddies')
          m.cb_item('Show Empty Groups')
          m.cb_item('Show Buddy Details')
          m.cb_item('Show Idle Times')
          m.submenu('Sort Buddies'){|sm|
            button_group(
              sm.rb_item('Manually'),
              sm.rb_item('Alphabetically', true),
              sm.rb_item('By Status'),
              sm.rb_item('By Log Size')
            )
          }
          m.separator
          m.item('Add Buddy...', 'a')
          m.item('Add Chat...', 'h')
          m.item('Add Group...', 'g')
          m.separator
          m.item('Quit', 'q'){|e|
            Java::JavaLang::System.exit 0
          }
        }
        bar.menu('Accounts'){|m|
          m.item('Add/Edit...')
          @accounts.each{|account|
            m.submenu(account){|sm|
              sm.item('Edit')
            }
          }
        }
        bar.menu('Tools'){|m|
          m.item('Buddy Pounces')
          m.item('Plugins')
          m.item('Preferences')
          m.item('Privacy')
          m.separator
          m.item('File Transfers')
          rl = m.item('Room List')
            rl.enabled = false
          m.item('System Log')
          m.separator
          m.item('Mute Sounds')
        }
        bar.menu('Help'){|m|
          m.item('Online Help')
          m.item('Debug Window')
          m.item('About', 'a')
        }
      }
      f.content_pane = border_panel(
        :center => scroll_pane(@contact_list = list(@buddies.to_java){|l|
          l.selection_background = color(147, 160, 112)
          l.cell_renderer = ContactListCellRenderer.new
          l.fixed_cell_height = 35
          l.add_mouse_listener(:clicked => proc {|e|
            if e.click_count == 2 then
              index = @contact_list.location_to_index(e.point)
              contact = @contact_list.model.get_element_at index
              dialog(@frame){|d|
                d.menubar {|mb|
                  mb.menu('Conversation'){|m|
                    m.mnemonic = 'c'[0]
                    m.item('New Instant Message...')
                  }
                }
                d.content_pane = box_panel(:y_axis,
                  label(contact),
                  scroll_pane(text_area{|msg_area|
                      msg_area.preferred_size = dimension(400, 300)
                    }){|sp|
                      sp.vertical_scroll_bar_policy = ScrollPaneConstants::VERTICAL_SCROLLBAR_ALWAYS
                    },
                  text_area{|typing_area|
                  
                  }
                ){|bp|
                  bp.border = bevel_border BevelBorder::RAISED
                }
                d.pack
              }.show
            end
          })
        }),
        :south => grid_bag_panel(
          :status_combo => button('Available', image_icon('pixmaps/status/16/available.png')){|b|
            b.horizontal_alignment = SwingConstants::LEFT
          },
          :display_icon => label(image_icon('pixmaps/purple/buddy_icons/qq/qq_5.png'))
        )
      )
      f.icon_image = Toolkit.getDefaultToolkit().getImage('pixmaps/logo.png')
      f.default_close_operation = JFrame::EXIT_ON_CLOSE
      f.size = dimension 300, 600
      f.visible = true
    }
  end
end

set_look_and_feel_to_system_default 

App.new