README for swing4rb
===================
swing4rb is a declarative approach to laying out Swing GUI components which makes Swing programming easier, more maintainable and more fun.

Installation
============
gem install swing4rb

Hello World
===========
Swing GUI's are laid out in nested blocks of ruby code rather than in an object oriented-procedural way. Example:
frame('Hello World'){|f|
  f.content_pane = panel {|p|
    p.add button('Hello World')
  }
  f.pack
  f.visible = true
}

This creates a JFrame with title 'Hello World' which has a button inside it that also says 'Hello World'.
