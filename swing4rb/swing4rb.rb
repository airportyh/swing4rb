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


require 'java'

def camelcase str
  str.gsub!(/[^a-zA-Z_\- ]/," ")
  str = " " + str.split('_').join(" ")
  str.gsub!(/ (.)/) { $1.upcase }
end

import javax.swing.SwingConstants
import java.awt.event.ActionListener
def pretty_action_listener *syms
  syms.each{|sym|
    eval(
    %Q|
    import javax.swing.#{camelcase(sym.to_s)}
    class #{camelcase(sym.to_s)}
      alias original_add_action_listener add_action_listener
      def add_action_listener &func
        l = ActionListener.new
        l.instance_eval {
          @func = func
        }
        def l.actionPerformed(event)
          @func.call(event)
        end
        l
        original_add_action_listener l
      end
    end
    |)
  }
end

pretty_action_listener :abstract_button, :j_combo_box, :j_file_chooser, :j_text_field, :timer
import javax.swing.BorderFactory
def border_fact_method *syms
  syms.each{|sym|
    eval %Q|
      def #{sym.to_s} *args
        BorderFactory.create#{camelcase(sym.to_s)} *args
      end
    |
  }
end

border_fact_method :line_border, :bevel_border, :compound_border, :etched_border
border_fact_method :matte_border, :raised_bevel_border, :titled_border, :empty_border, :lowered_bevel
import javax.swing.JList
import javax.swing.event.ListSelectionListener
class JList
  alias original_add_list_selection_listener add_list_selection_listener
  def add_list_selection_listener &block
    l = ListSelectionListener.new
    l.instance_eval {
      @listener = block
    }
    def l.valueChanged(event)
      @listener.call(event)
    end
    original_add_list_selection_listener l
  end
end   
import java.awt.Component
import java.awt.event.MouseListener
import java.awt.event.KeyListener
class Component
  alias original_add_mouse_listener add_mouse_listener
  alias original_add_key_listener add_key_listener
  def add_mouse_listener map
    l = MouseListener.new
    [:clicked, :entered, :exited, :pressed, :released].each{|key|
      value = map[key]
      if value.nil? then
        value = proc{|event| }
      end
      eval %Q|l.instance_eval {
        @#{key} = value
      }|
      eval %Q|
        def l.mouse#{key.to_s.capitalize}(event)
          @#{key}.call(event)
        end
      |
    }
    original_add_mouse_listener l 
  end
  
  def add_key_listener map
    l = KeyListener.new
    [:pressed, :released, :typed].each{|key|
      value = map[key]
      if value.nil? then
        value = proc{|event| }
      end
      eval %Q|l.instance_eval {
        @#{key} = value
      }|
      eval %Q|
        def l.key#{key.to_s.capitalize}(event)
          @#{key}.call(event)
        end
      |
    }
    original_add_key_listener l 
  end
  
  def center_on_screen
    ss = java.awt.Toolkit.getDefaultToolkit().getScreenSize()
		cs = self.size
		self.setLocation((ss.width - cs.width) / 2, (ss.height - cs.height) / 2);
	end
end

import java.awt.event.ActionEvent
class ActionEvent
  alias action_command getActionCommand
end

import javax.swing.JPanel
class JPanel
  alias layout getLayout
end

import javax.swing.JFrame
class JFrame
  def menubar
    bar = JMenuBar.new
    if block_given?
      yield bar
    end
    self.setJMenuBar bar
    bar
  end
end

import javax.swing.JDialog
class JDialog
  def menubar
    bar = JMenuBar.new
    if block_given?
      yield bar
    end
    self.setJMenuBar bar
    bar
  end
end

import javax.swing.JMenuBar
class JMenuBar
  def menu name
    menu = JMenu.new name
    if block_given?
      yield menu
    end
    self.add menu
    menu
  end
end

import javax.swing.JMenu
import javax.swing.JMenuItem
import javax.swing.JCheckBoxMenuItem
import javax.swing.JRadioButtonMenuItem
class JMenu

  alias separator add_separator
  def item *args, &action_listener
    _item args, &action_listener
  end
  
  def _item args, clazz=JMenuItem, &action_listener
    if args.length == 2 and args[1].class == String
      shortcut = args[1]
      shortcut = shortcut[0] unless shortcut.nil? or shortcut.length == 0
      args[1] = shortcut
    end
    item = clazz.new *args
    if block_given?
      item.add_action_listener &action_listener
    end
    self.add item
    item
  end
  
  def check_box_item *args, &block
    self._item args, JCheckBoxMenuItem, &block
  end
  
  def radio_button_item *args, &block
    self._item args, JRadioButtonMenuItem, &block
  end
  
  def submenu name
    menu = JMenu.new name
    if block_given?
      yield menu
    end
    self.add menu
    menu
  end
  alias cb_item check_box_item
  alias rb_item radio_button_item
end

def fact_method name, clazz, clazz_full
    #puts "creating #{name} for #{clazz}"
    eval %Q|
      if not defined? #{clazz}
        import #{clazz_full}
      end
      def #{name} *args
        #{name} = #{clazz}.new *args
        if block_given?
          yield #{name}
        end
        #{name}
      end
      |
end

def fact_method_j *syms
  syms.each {|sym|
    name = sym.to_s
    clazz = "J" + camelcase(name)
    fact_method name, clazz, "javax.swing." + clazz
  }
end

def awt_fact_method *syms
  syms.each {|sym|
    name = sym.to_s
    clazz = camelcase(name)
    fact_method name, clazz, "java.awt." + clazz
  }
end

def swing_fact_method *syms
  syms.each {|sym|
    name = sym.to_s
    clazz = camelcase(name)
    fact_method name, clazz, "javax.swing." + clazz
  }
end

fact_method_j :frame, :panel, :button, :text_area, :scroll_pane, :text_field, :label, :tool_bar
fact_method_j :text_field, :password_field, :progress_bar, :list, :combo_box, :dialog, :tabbed_pane
awt_fact_method :border_layout, :flow_layout, :dimension, :point, :card_layout
swing_fact_method :box_layout, :image_icon, :default_list_cell_renderer
awt_fact_method :grid_layout, :color, :grid_bag_constraints, :insets, :grid_bag_layout
alias gbc grid_bag_constraints

import javax.swing.ButtonGroup
def button_group *buttons
  bg = ButtonGroup.new
  buttons.each{|button|
    bg.add button
  }
  bg
end
def border_panel map
  panel {|p|
    p.layout = border_layout
    map.each do |key, value|
      c = eval("BorderLayout::#{key.to_s.upcase}")
      p.add(value, c)
    end
    if block_given?
      yield p
    end
  }
end

def flow_panel *components
  panel {|p|
    p.layout = flow_layout
    components.each{|c|
      p.add(c)
    }
    if block_given?
      yield p
    end
  }
end
def box_panel axis, *components
  panel {|p|
    p.layout = box_layout(p, eval("BoxLayout::#{axis.to_s.upcase}"))
    components.each{|c|
      p.add(c)
    }
    if block_given?
      yield p
    end
  }
end

def card_panel map
  panel {|p|
    p.layout = card_layout
    map.each {|key, value|
      p.add(value, key.to_s)
    }
    if block_given?
      yield p
    end
  }
end

def grid_panel columns, rows, *components
  panel {|p|
    p.layout = grid_layout columns, rows
    components.each{|c|
      p.add c
    }
    if block_given?
      yield p
    end
  }
end

@@grid_bag_constraints = {}
def setup_grid_bag_constraints map
  @@grid_bag_constraints = map
end
def grid_bag_panel id_to_component
  panel {|p|
    p.layout = grid_bag_layout
    id_to_component.each{|key, value|
      if @@grid_bag_constraints[key] then
        p.add value, @@grid_bag_constraints[key]
      else
        p.add value
      end
    }
    if block_given?
      yield p
    end
  }
end
import javax.swing.UIManager
def set_look_and_feel_to_system_default
  UIManager.look_and_feel = UIManager.system_look_and_feel_class_name
end