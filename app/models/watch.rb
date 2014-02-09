class Watch < ActiveRecord::Base
  belongs_to :user

  STATUS = {
    ongoing: "Ongoing",
    done:    "Done"
  }

  validates :status, :inclusion => STATUS.values

  before_validation :default_status

  private
  def default_status
    if new_record?
      self.status = STATUS[:ongoing]
    end

    true
  end
end
