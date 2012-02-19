notification :libnotify, :timeout => 5, :transient => true, :append => false, hint: "int:transient:1"

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', :cli => "--color --drb", :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

require 'guard/guard'
require 'grit'

module ::Guard
  class GritGuard < ::Guard::Guard

    def initialize
      super
      @repo = ::Grit::Repo.new(Dir.pwd)
    end

    def run_on_change(paths)
      UI.info "Git Status: M:#{@repo.status.changed.keys.count} A:#{@repo.status.added.keys.count} D:#{@repo.status.deleted.keys.count} U:#{@repo.status.untracked.keys.count}"
    end
  end
end

