namespace :gem do
  spec = Gem::Specification.load('gemspec')
  vcs = 'git' if File.exist?('.git')
  vcs = 'hg' if File.exist?('.hg')

  raise 'gemesis requires a git or mercurial repository' unless vcs

  desc "push new #{spec.name} release and #{vcs} tag"
  task :push => :build_gem do
    sh "#{vcs} tag #{spec.version}" if vcs
    sh "gem push #{spec.name}-#{spec.version}.gem"
  end

  task :build_gem do
    sh "gem build gemspec"
  end

  desc "install #{spec.name} locally"
  task :install => :build_gem do
    sh "gem install #{spec.name}-#{spec.version}.gem --no-ri --no-rdoc"
  end

  desc "uninstall #{spec.name} locally"
  task :uninstall => :build_gem do
    sh "gem uninstall #{spec.name} -x -a"
  end

  desc "reinstall #{spec.name} locally"
  task :reinstall => [:uninstall, :install]
end
