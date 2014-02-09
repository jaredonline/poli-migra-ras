class SmsRouter < Txt::Routing::Base
  route "ALL",    :controller => :watch, :action => :broadcast
  route "WATCH",  :controller => :watch, :action => :new
  route "DONE",   :controller => :watch, :action => :finish
  route "VERIFY", :controller => :watch, :action => :verify

  default         :controller => :watch, :action => :four_oh_four
end
