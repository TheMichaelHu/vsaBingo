class Room < ActiveRecord::Base
  has_many :players
  after_initialize :init

  def init
    self.code ||= (0...5).map do ('A'..'Z').to_a[rand(26)] end.join
  end
end
