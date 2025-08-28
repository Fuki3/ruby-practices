# frozen_string_literal: true

class ShortFormatter
  COL = 3

  def initialize(names)
    @names = names
  end

  def format
    row_count = @names.size.ceildiv(COL)
    max_bytesize = @names.max_by(&:bytesize).bytesize
    cols = @names.each_slice(row_count)
    lines = Array.new(row_count) do |idx|
      cols.map do |col|
        col[idx].ljust(max_bytesize)
      end
    end
    lines.each do |name|
      puts name.join(' ')
    end
  end
end
