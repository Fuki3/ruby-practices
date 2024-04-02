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

if params == { l: true }
  file_type_eight = @files.map { |file| File.stat(file).mode.to_s(8) }
  file_type = []
  file_type_eight.each do |file|
    file[0..1] == '01' && file[0..1] = 'p'
    file[0..1] == '02' && file[0..1] = 'c'
    file[0..1] == '04' && file[0..1] = 'd'
    file[0..1] == '06' && file[0..1] = 'b'
    file[0..1] == '10' && file[0..1] = '-'
    file[0..1] == '12' && file[0..1] = 'l'
    file[0..1] == '14' && file[0..1] = 's'
    i = 2
    while i < 9
      file[i] = case file[i]
                when '0' then '---'
                when '1' then '--x'
                when '2' then '-w-'
                when '3' then '-wx'
                when '4' then 'r--'
                when '5' then 'r-x'
                when '6' then 'rw-'
                else 'rwx'
                end
      i += 3
    end
    file[10] = file[10] == 'x' ? 't' : 'T' if file[1] == '1'
    file[7] = file[7] == 'x' ? 's' : 'S' if file[1] == '2'
    file[4] = file[4] == 'x' ? 's' : 'S' if file[1] == '4'
    file_type << "#{file.slice(0)}#{file.slice(2..10)} "
  end

  file_blocks = @files.map { |file| File.stat(file).blocks }.sum
  file_nlink_without_space = @files.map { |file| File.stat(file).nlink.to_s }
  file_nlink = file_nlink_without_space.map { |file| ' ' * (file_nlink_without_space.max.size - file.size) + file }
  file_owner_wituout_space = @files.map { |file| File.stat(file).uid }.map { |file| Etc.getpwuid(file).name }
  file_owner = file_owner_wituout_space.map { |file| file + ' ' * (file_owner_wituout_space.max.size - file.size + 1) }
  file_group_wituout_space = @files.map { |file| File.stat(file).gid }.map { |file| Etc.getgrgid(file).name }
  file_group = file_group_wituout_space.map { |file| file + ' ' * (file_group_wituout_space.max.size - file.size + 1) }
  file_size_without_space = @files.map { |file| File.stat(file).size.to_s }
  file_size = file_size_without_space.map { |file| ' ' * (file_size_without_space.max.size - file.size) + file }
  file_month = @files.map { |file| File.stat(file).mtime.to_s[5..6] }
  file_month.map { |file| file[0] = ' ' if file[0] == '0' }
  file_day = @files.map { |file| File.stat(file).mtime.to_s[8..9] }
  file_day.map { |file| file[0] = ' ' if file[0] == '0' }
  file_time = @files.map { |file| File.stat(file).mtime.to_s[11..15] }
  file_l_element = [file_type] + [file_nlink] + [file_owner] + [file_group] + [file_size] + [file_month] + [file_day] + [file_time] + [@files]

  file_l = Array.new(@files.size) do |t|
    file_l_element.map { |file| file[t] }
  end

  puts "total #{file_blocks}"

  n = 0
  while n < @files.size
    puts file_l[n].join(' ')
    n += 1
  end

else
  def bytesize(array_element)
    array_element.encode('EUC-JP').bytesize
  end

  def slice(first, final, element_count)
    @files[first..final].each_slice(element_count).to_a
  end

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
