# frozen_string_literal: true

class FileDetail
  attr_reader :name

  REPLACE_FILE_TYPE = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze

  REPLACE_ACCESS_PRIVILEGE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def mode
    mode_eight = format('%06d', @stat.mode.to_s(8))
    type = mode_eight[0..1].gsub(/../, REPLACE_FILE_TYPE)
    access_privilege = mode_eight[3..5].gsub(/\d/, REPLACE_ACCESS_PRIVILEGE)
    access_privilege[8] = access_privilege[8] == 'x' ? 't' : 'T' if mode_eight[2] == '1'
    access_privilege[5] = access_privilege[5] == 'x' ? 's' : 'S' if mode_eight[2] == '2'
    access_privilege[2] = access_privilege[2] == 'x' ? 's' : 'S' if mode_eight[2] == '4'
    "#{type}#{access_privilege} "
  end

  def blocks
    @stat.blocks
  end

  def nlink
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def timestamp
    month = format('%2d', @stat.mtime.to_s[5..6].to_i)
    day = format('%2d', @stat.mtime.to_s[8..9].to_i)
    time = @stat.mtime.to_s[11..15]
    [month, day, time]
  end
end
