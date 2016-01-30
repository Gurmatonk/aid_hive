module Locatable
  extend ActiveSupport::Concern

  included do
    geocoded_by :address_line

    def self.require_locatable_attributes
      validates :postal_code, presence: true
      validates :city, presence: true
    end

    after_validation :geocode

    def address_line
      result = "#{street_name_and_number}, " if street_name.present?
      "#{result}#{postal_code_and_city}"
    end

    def street_name_and_number
      result = "#{street_name}"
      result << " #{street_number}" unless street_number.blank?
    end

    def postal_code_and_city
      "#{postal_code} #{city}"
    end

    def name_and_address_line
      "#{display_name}, #{address_line}"
    end
  end
end
