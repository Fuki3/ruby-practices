# frozen_string_literal: true

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

class FileDetail
  def initialize(files)
    @files = files
    @file_nlink_max = @files.map { |file| File.stat(file).nlink.to_s.size }.max
    @file_owner_max = @files.map { |file| Etc.getpwuid(File.stat(file).uid).name }.max.size
    @file_group_max = @files.map { |file| Etc.getgrgid(File.stat(file).gid).name }.max.size
    @file_size_max = @files.map { |file| File.stat(file).size.to_s.size }.max
  end

  def count_blocks_sum
    puts "total #{@files.map { |file| File.stat(file).blocks }.sum}"
  end

  def stat_file
    @files.each do |file|
      file_stat = File.stat(file)
      file_mode_eight = format('%06d', file_stat.mode.to_s(8))
      file_type = file_mode_eight[0..1].gsub(/../, REPLACE_FILE_TYPE)
      file_access_privilege = file_mode_eight[3..5].gsub(/\d/, REPLACE_ACCESS_PRIVILEGE)
      file_access_privilege[8] = file_access_privilege[8] == 'x' ? 't' : 'T' if file_mode_eight[2] == '1'
      file_access_privilege[5] = file_access_privilege[5] == 'x' ? 's' : 'S' if file_mode_eight[2] == '2'
      file_access_privilege[2] = file_access_privilege[2] == 'x' ? 's' : 'S' if file_mode_eight[2] == '4'
      file_mode = "#{file_type}#{file_access_privilege} "

      file_nlink = ' ' * (@file_nlink_max - file_stat.nlink.to_s.size) + file_stat.nlink.to_s
      file_owner = Etc.getpwuid(file_stat.uid).name + ' ' * (@file_owner_max - Etc.getpwuid(file_stat.uid).name.size + 1)
      file_group = Etc.getgrgid(file_stat.gid).name + ' ' * (@file_group_max - Etc.getgrgid(file_stat.gid).name.size + 1)
      file_size = ' ' * (@file_size_max - file_stat.size.to_s.size) + file_stat.size.to_s
      file_month = format('%2d', file_stat.mtime.to_s[5..6].to_i)
      file_day = format('%2d', file_stat.mtime.to_s[8..9].to_i)
      file_time = file_stat.mtime.to_s[11..15]
      puts [file_mode, file_nlink, file_owner, file_group, file_size, file_month, file_day, file_time, file].join(' ')
    end
  end

  def set_filedetail
    count_blocks_sum
    stat_file
  end
end
