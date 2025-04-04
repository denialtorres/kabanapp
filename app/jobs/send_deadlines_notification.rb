class SendDeadlinesNotification < ApplicationJob
  queue_as :critical

  def perform
    # find the time zones list for an specific hour
    # in what places is it 9pm for example
    # =>  ["Central Time (US & Canada)", "Bogota", "Lima", "Quito"]
    time_zones = find_time_zones_for_daily_digest

    return if time_zones.empty?

    puts "DAILY DIGEST FOR TIMEZONES: #{time_zones}"

    # select any time zone from the list since its basically the same
    # and the the current date without worry about the minutes
    current_date= ActiveSupport::TimeZone[time_zones.first].now.beginning_of_hour.to_date

    # for testing
    # set dates like Date.new(2025, 3, 15)
    # User.update_all(preferred_time_zone: "Muscat")
    users_with_deadlines = find_users_with_deadlines(time_zones, current_date)

    users_with_deadlines.each do |user, cards|
      send_notification(user, cards)
    end
  end

  private

  def find_time_zones_for_daily_digest
    # 00 hours == 12:00
    daily_digest_time_zones.select { |tz| tz.now.hour == 00 }.map(&:name)
  end

  def daily_digest_time_zones
    ActiveSupport::TimeZone.all
  end

  def find_users_with_deadlines(time_zones, current_date)
    # return a hash
    # User Object => Cards Array
    User
      .where(preferred_time_zone: time_zones)
      .joins(:user_cards)
      .joins("INNER JOIN cards ON user_cards.card_id = cards.id")
      .where("cards.deadline_at = ?", current_date)
      .distinct
      .each_with_object({}) do |user, hash|
        hash[user] = user.cards.where(deadline_at: current_date)
      end
  end

  def send_notification(user, cards)
    puts "-------"
    puts "Sending notification to #{user.email} for cards: #{cards.pluck(:id, :name)}"
    puts "-------"
    # UserMailer.deadline_notification(user, cards).deliver_later
  end
end
