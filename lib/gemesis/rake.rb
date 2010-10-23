namespace :gem do
  spec = Gem::Specification.load('gemspec')
  vcs = 'git' if File.exist?('.git')
  vcs = 'hg' if File.exist?('.hg')

  desc "release new #{spec.name} - push then increment patch"
  task :release => [:push, :patch] do
    if vcs
      sh "#{vcs} add gemspec"
      sh "#{vcs} commit -m \"bumped version for next release\""
    end
  end

  desc "push new #{spec.name} release and #{vcs} tag"
  task :push => :build do
    sh "#{vcs} tag #{spec.version}" if vcs
    sh "gem push #{spec.name}-#{spec.version}.gem"
  end

  desc "build #{spec.name} gem file"
  task :build do
    sh "gem build gemspec"
  end

  desc "install #{spec.name} locally"
  task :install => :build do
    sh "#{ENV['SUDO']} gem install #{spec.name}-#{spec.version}.gem --no-ri --no-rdoc"
  end

  desc "uninstall #{spec.name} locally"
  task :uninstall => :build do
    sh "#{ENV['SUDO']} gem uninstall #{spec.name} -x -a"
  end

  desc "reinstall #{spec.name} locally"
  task :reinstall => [:uninstall, :install]

  def bump
    FileUtils.mv 'gemspec', 'gemspec.tmp'

    File.open('gemspec','w') do |io_out|
      File.open('gemspec.tmp') do |io_in|
        io_in.each do |line|
          line.chomp!
          if line =~ /version = '(\d+)\.(\d+)\.(\d+)'/
            versions = [$1.to_i,$2.to_i,$3.to_i]
            yield versions
            io_out.puts "  s.version = '#{versions.join('.')}'"
          else
            io_out.puts line
          end
        end
      end
    end
    
    FileUtils.rm 'gemspec.tmp'
  end
  
  desc "bump major version"
  task :major do
    bump {|versions| versions[0] += 1}
  end

  desc "bump minor version"
  task :minor do
    bump {|versions| versions[1] += 1}
  end

  desc "bump patch version"
  task :patch do
    bump {|versions| versions[2] += 1}
  end
end