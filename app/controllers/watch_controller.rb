class WatchController < Txt::Controller::Base
  def broadcast
    with_user_and_active_watch do |user, watch|
      User.where("id <> ?", user.id).each do |u|
        u.send_message <<-MESSAGE
          #{user.name} broadcasts: #{message}
        MESSAGE
      end

      response_message "Your message has been broadcast."
    end
  end

  def new
    with_user do |user|
      watch = Watch.new(:user => user, :message => self.message)
      if watch.save
        User.where("id <> ?", user.id).each do |u|
          u.send_message <<-MESSAGE
          #{user.name} just initiated a watch: #{self.message}
          MESSAGE
        end
        response_message "Watch initiated with message: #{message}"
      else
        response_message "Something went wrong; the watch was not initiated."
      end
    end
  end

  def respond
    with_user_and_active_watch do |user, watch|
      watch.user.send_message <<-MESSAGE
      #{user.name} responds: #{message}
      MESSAGE

      response_message "Your response was sent to #{watch.user.name}"
    end
  end

  def finish
    with_active_watch do |watch|
      if user == watch.user
        watch.update_attributes(status: Watch::STATUS[:done])
        User.where("id <> ?", watch.user_id).each do |u|
          u.send_message <<-MESSAGE
          #{watch.user.name} has ended their watch: #{watch.message}
          MESSAGE
        end

        response_message "Your watch (initiated with \"#{watch.message}\") has been ended."
      else
        no_response
      end
    end
  end

  def verify
    with_user_and_active_watch do |user, watch|
      watch.user.send_message <<-MESSAGE
        Your watch was just verified by #{user.name}
      MESSAGE

      response_message "Watch \"#{watch.message}\" has been verified."
    end
  end

  private
  def user
    @user ||= User.find_by_number(self.number)
  end

  def active_watch
    @active_watch ||= Watch.where(status: Watch::STATUS[:ongoing]).last
  end

  def with_user
    if user.present?
      yield(user)
    else
      no_response
    end
  end

  def with_active_watch
    if active_watch.present?
      yield(active_watch)
    else
      no_response
    end
  end

  def with_user_and_active_watch
    with_user do |user|
      with_active_watch do |watch|
        yield(user, watch)
      end
    end
  end
end
