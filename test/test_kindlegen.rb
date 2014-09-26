require 'test/unit'
require 'rubygems/uninstaller'
KINDLEGEN_PROJECT_DIR = File.expand_path(File.dirname(File.dirname(__FILE__)))
$:.delete(File.join(KINDLEGEN_PROJECT_DIR, 'lib'))

class KindlegenTest < Test::Unit::TestCase
  def test_gem_install
    kindlegen_lib_dir = nil
    gem_version = File.read(File.join(KINDLEGEN_PROJECT_DIR, 'lib/kindlegen/version.rb')).match(/VERSION = ["'](.*?)["']/)[1]
    gem_file = File.join(KINDLEGEN_PROJECT_DIR, 'pkg', %(kindlegen-#{gem_version}.gem))
    result = Gem.install gem_file
    begin
      require 'kindlegen'
    rescue ::LoadError
      kindlegen_lib_dir = ::File.join(result[0].gem_dir, 'lib')
      $:.unshift kindlegen_lib_dir
      require 'kindlegen'
    end
    output = %x(#{Kindlegen.command})
    assert output.include?('Amazon')
  ensure
    Gem::Uninstaller.new('kindlegen', :force => true).uninstall rescue nil
    $:.delete kindlegen_lib_dir if kindlegen_lib_dir
  end
end