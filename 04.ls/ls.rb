# frozen_string_literal: true

require 'optparse'
require 'etc'

COL = 3

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

def replace01
  @replace_file_type = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze
end

def replace234
  @replace_access_privilege = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze
end

if params == { l: true }

  puts "total #{@files.map { |file| File.stat(file).blocks }.sum}"

  file_type_eight = @files.map { |file| File.stat(file).mode.to_s(8) }
  file_types = []
  file_type_eight.each do |file_type|
    replace01
    file_type[0..1] = @replace_file_type[file_type[0..1]]

    replace234
    [2, 5, 8].each do |i|
      file_type[i] = file_type[i].gsub(file_type[i], @replace_access_privilege)
    end

    file_type[10] = file_type[10] == 'x' ? 't' : 'T' if file_type[1] == '1'
    file_type[7] = file_type[7] == 'x' ? 's' : 'S' if file_type[1] == '2'
    file_type[4] = file_type[4] == 'x' ? 's' : 'S' if file_type[1] == '4'
    file_types << "#{file_type.slice(0)}#{file_type.slice(2..10)} "
  end

  file_nlink_max = @files.map { |file| File.stat(file).nlink.to_s }.max.size
  file_owner_max = @files.map { |file| File.stat(file).uid }.map { |file| Etc.getpwuid(file).name }.max.size
  file_group_max = @files.map { |file| File.stat(file).gid }.map { |file| Etc.getgrgid(file).name }.max.size
  file_size_max = @files.map { |file| File.stat(file).size.to_s }.max.size

  @files.map.with_index do |file, i|
    file_nlink = ' ' * (file_nlink_max - File.stat(file).nlink.to_s.size) + File.stat(file).nlink.to_s
    file_owner = Etc.getpwuid(File.stat(file).uid).name + ' ' * (file_owner_max - Etc.getpwuid(File.stat(file).uid).name.size + 1)
    file_group = Etc.getgrgid(File.stat(file).gid).name + ' ' * (file_group_max - Etc.getgrgid(File.stat(file).gid).name.size + 1)
    file_size = ' ' * (file_size_max - File.stat(file).size.to_s.size) + File.stat(file).size.to_s
    file_month = File.stat(file).mtime.to_s[5..6]
    file_month[0] = ' ' if file_month[0] == '0'
    file_day = File.stat(file).mtime.to_s[8..9]
    file_day[0] = ' ' if file_day[0] == '0'
    file_time = File.stat(file).mtime.to_s[11..15]
    puts [[file_types[i]] + [file_nlink] + [file_owner] + [file_group] + [file_size] + [file_month] + [file_day] + [file_time] + [file]].join(' ')
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
