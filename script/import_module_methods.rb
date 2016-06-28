#!/usr/bin/env rails runner
require 'method_locator'
MODULE_NAME_SPACES_TO_IMPORT = %w(hydra curate sufia)

if ARGV.grep(/^-+h(elp)$/i).size == 1 || ARGV.empty?
  $stdout.puts ""
  $stdout.puts "$ ./script/#{File.basename(__FILE__)} <filename>"
  $stdout.puts ""
  $stdout.puts "This script will import the method definitions of included modules."
  $stdout.puts "It accounts for modules that leverage ActiveSupport::Concern's DSL."
  $stdout.puts ""
  $stdout.puts "NOTES:"
  $stdout.puts "* It ignores modules not in the #{MODULE_NAME_SPACES_TO_IMPORT.inspect} namespaces."
  $stdout.puts "* It is not recursive, though you can run it multiple times."
  $stdout.puts "* It does not account for uses of `super`."
  $stdout.puts "* It will not find nested include declarations unless through `ActiveSupport::Concern.included`"
  $stdout.puts ""
  exit(0)
end

filename = ARGV[0]
if filename.blank?
  $stderr.puts "Please provide a filename"
  exit(1)
end

def extract_instance_methods(module_constant, lines_of_text)
  ['public', 'protected', 'private'].each do |scope|
    scoped_instance_methods = module_constant.public_send("#{scope}_instance_methods")
    next unless scoped_instance_methods.any?
    scoped_instance_methods.each do |method_name|
      method = module_constant.instance_method(method_name)
      lines_of_text << ""
      lines_of_text << method.comment if method.comment.present?
      lines_of_text << method.source
      lines_of_text << "#{scope} :#{method_name}"
    end
  end
  lines_of_text << ""
  lines_of_text
end

def extract_active_support_class_methods(module_constant, lines_of_text)
  ['public', 'protected', 'private'].each do |scope|
    scoped_instance_methods = module_constant.public_send("#{scope}_instance_methods")
    next unless scoped_instance_methods.any?
    scoped_instance_methods.each do |method_name|
      method = module_constant.instance_method(method_name)
      method_source = method.source
      lines_of_text << ""
      lines_of_text << method.comment if method.comment.present?
      lines_of_text << method_source.gsub(/(\s+def\s)/, '\1self.')
      lines_of_text << "#{scope}_class_method :#{method_name}"
    end
  end
  lines_of_text << ""
  lines_of_text
end


def extract_active_support_concern(module_constant, lines_of_text)
  return lines_of_text unless module_constant.is_a?(ActiveSupport::Concern)
  if module_constant.const_defined?(:ClassMethods)
    lines_of_text = extract_active_support_class_methods(module_constant::ClassMethods, lines_of_text)
  end
  lines_of_text = extract_active_support_included_methods(module_constant, lines_of_text)
  lines_of_text
end

def extract_active_support_included_methods(module_constant, lines_of_text)
  included_block = module_constant.instance_variable_get(:@_included_block)
  return lines_of_text unless included_block.present?
  included_block_body = included_block.source.strip.sub(/\Aincluded (do|{)/, '').sub(/(end|})\Z/, '').strip
  lines_of_text << included_block_body
  lines_of_text
end

VISUAL_LINE_BREAK = "#" * 80
def extract_module_methods(line, module_name)
  return line unless module_name =~ /\A(#{MODULE_NAME_SPACES_TO_IMPORT.join('|')})/i
  module_constant = module_name.constantize
  lines_of_text = ["", VISUAL_LINE_BREAK, "# BEGIN Replacing #{line.strip}", VISUAL_LINE_BREAK]
  lines_of_text = extract_instance_methods(module_constant, lines_of_text)
  if module_constant == Curate::UserBehavior
    require 'byebug'; debugger; true
  end
  lines_of_text = extract_active_support_concern(module_constant, lines_of_text)
  lines_of_text << ""
  lines_of_text << "# END Replacing #{line.strip}"
  lines_of_text << VISUAL_LINE_BREAK
  lines_of_text << ""
  lines_of_text.map(&:strip).join("\n")
end

contents = File.read(filename)
contents.gsub!(/^\s +include ([\w\:]+).*$/) do |line|
  module_name = $1
  extract_module_methods(line, module_name)
end

File.open(filename, 'w+') do |file|
  file.puts contents
end
`rbeautify #{filename} --overwrite -s -c2`
