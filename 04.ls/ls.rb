# frozen_string_literal: true

require 'optparse'
require 'etc'

COL = 3

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

opt = OptionParser.new
params = {}
opt.on('-a') { |v| params[:a] = v }
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }
opt.parse(ARGV)

@files = params == { a: true } ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
@files = @files.sort.reverse if params == { r: true }
element_number = @files.size / COL
remainder = @files.size % COL

def bytesize(array_element)
  array_element.encode('EUC-JP').bytesize
end

def slice(first, final, element_count)
  @files[first..final].each_slice(element_count).to_a
end

if params == { l: true }

  puts "total #{@files.map { |file| File.stat(file).blocks }.sum}"

  file_nlink_max = @files.map { |file| File.stat(file).nlink.to_s }.max.size
  file_owner_max = @files.map { |file| Etc.getpwuid(File.stat(file).uid).name }.max.size
  file_group_max = @files.map { |file| Etc.getgrgid(File.stat(file).gid).name }.max.size
  file_size_max = @files.map { |file| File.stat(file).size.to_s.size }.max

  @files.each do |file|
    file_stat = File.stat(file)
    file_mode_eight = format('%06d', file_stat.mode.to_s(8))
    file_type = file_mode_eight[0..1].gsub(/../, REPLACE_FILE_TYPE)
    file_access_privilege = file_mode_eight[3..5].gsub(/\d/, REPLACE_ACCESS_PRIVILEGE)
    file_access_privilege[8] = file_access_privilege[8] == 'x' ? 't' : 'T' if file_mode_eight[2] == '1'
    file_access_privilege[5] = file_access_privilege[5] == 'x' ? 's' : 'S' if file_mode_eight[2] == '2'
    file_access_privilege[2] = file_access_privilege[2] == 'x' ? 's' : 'S' if file_mode_eight[2] == '4'
    file_mode = "#{file_type}#{file_access_privilege} "

    file_nlink = ' ' * (file_nlink_max - file_stat.nlink.to_s.size) + file_stat.nlink.to_s
    file_owner = Etc.getpwuid(file_stat.uid).name + ' ' * (file_owner_max - Etc.getpwuid(file_stat.uid).name.size + 1)
    file_group = Etc.getgrgid(file_stat.gid).name + ' ' * (file_group_max - Etc.getgrgid(file_stat.gid).name.size + 1)
    file_size = ' ' * (file_size_max - file_stat.size.to_s.size) + file_stat.size.to_s
    file_month = format('%2d', file_stat.mtime.to_s[5..6].to_i)
    file_day = format('%2d', file_stat.mtime.to_s[8..9].to_i)
    file_time = file_stat.mtime.to_s[11..15]
    puts [file_mode, file_nlink, file_owner, file_group, file_size, file_month, file_day, file_time, file].join(' ')
  end

else

  file_size_max = @files.map { |file| bytesize(file) }.max

  if @files.size <= COL
    files_include_space = @files.map { |file| "#{file}#{' ' * (file_size_max - bytesize(file))} " }
    puts files_include_space.join

  else
    if remainder != 0
      col_array_include_remainder = slice(0, ((element_number + 1) * (@files.size / (element_number + 1))) - 1, element_number + 1)
      col_array_without_remainder = slice(((element_number + 1) * (@files.size / (element_number + 1))), -1, element_number + 1)
      col_array = col_array_include_remainder + col_array_without_remainder
      row_array = Array.new((element_number + 1)) do |m|
        col_array.map { |k| k[m] }.compact.map { |p| "#{p}#{' ' * (file_size_max - bytesize(p))} " }
      end
    else
      col_array = @files.each_slice(element_number)
      row_array = Array.new(element_number) do |m|
        col_array.map { |k| "#{k[m]}#{' ' * (file_size_max - bytesize(k[m]))} " }
      end
    end

    row_array.map { |array| puts array.map(&:to_s).join }

  end
end
