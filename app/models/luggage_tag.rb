class LuggageTag < ApplicationRecord
  validates :origin, :destination, :start, :end, presence: true

  validates :found_by, :found_comment, presence: true, if: :report_found

  before_create :generate_uuid
  belongs_to :user

  attr_accessor :report_found

  def lost!
    update_column :lost_at, Time.now unless new_record?
  end

  def found!
    update_column :found_at, Time.now unless new_record?
  end

  def ok!
    update_column :ok_at, Time.now unless new_record?
  end


  private
  def generate_uuid
    begin
      generated_uuid = SecureRandom::uuid
    end while LuggageTag.exists? uuid: generated_uuid
    self['uuid'] = generated_uuid
  end
end
