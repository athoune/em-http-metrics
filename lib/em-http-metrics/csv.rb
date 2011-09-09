require 'csv'

module Metrics
  class Metrics

    # Dump metrics as a CSV
    def to_csv sep=";"
      csv = CSV.new "", :col_sep => sep
      first = true
      self.each do |row|
        if first
          csv << row.keys
          first = false
        end
        csv << row.values
      end
      csv
    end

  end
end
