class User < ActiveRecord::Base
  has_many :watches

  validates_presence_of :name, :number

  def send_message(message)
    Txt::Sender.send_message(message, number)
  end
end
