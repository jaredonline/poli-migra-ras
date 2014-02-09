module Drip
  class Routing::Table < Routing::Base
    route "BREW", :controller => :brews, :action => :new
    route "YES",  :controller => :brews, :action => :subscribe
    route "DONE", :controller => :brews, :action => :finish
    route "HELP", :controller => :brews, :action => :help

    default :controller => :brews, :action => :four_oh_four
  end
end
