require "bundler/gem_tasks"
require "rake/testtask"
require "tmpdir"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc 'Run tests'
task :default => :test

desc 'Publish documentation'
task :publish_docs do
  raise 'Outstanding changes' unless `git status`.include?('nothing to commit')
  begin
    # get the current git branch
    starting_branch = orphan_exists = nil
    `git branch --no-color`.each_line do |line|
      branch          = line.gsub('*', '').strip
      starting_branch = branch if line[0] == '*'
      orphan_exists   ||= (branch == 'gh-pages')
    end

    # generate docs
    `yard --markup markdown`

    # copy them to a temp dir
    tmp_dir = Dir.tmpdir
    FileUtils.cp_r('doc', tmp_dir)

    # switch to gh-pages branch
    if orphan_exists
      cmd = 'git checkout gh-pages'
    else
      cmd = 'git checkout --orphan gh-pages'
    end
    result = system(cmd)
    raise "#{cmd} returned #{result}" unless result

    # wipe it clean and copy the docs back into it
    `git rm -rf .`
    `cp -r #{File.join(tmp_dir, 'doc', '*')} .`

    # commit and push
    `git add *`
    `git commit -m 'Update website'`
    `git push origin gh-pages`
  ensure
    # cleanup
    FileUtils.rm_rf(File.join(tmp_dir, 'doc'))
    `git checkout #{starting_branch}`
  end
end
