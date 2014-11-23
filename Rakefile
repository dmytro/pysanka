namespace :build do

  desc "mPurpose: Build CSS from LESS"
  task :css => :material do
    sh "lessc src/less/main.less > stylesheets/main.css"
  end

  desc "Copy bootstrap material CSS to project"
  task :material => ["build:material:css", "build:material:js", "build:material:fonts" ] do
  end

  namespace :material do

    task :src do
      @source = "src/bootstrap-material-design/dist"
    end

    task :css => :src do
      sh "cp -r #{ @source }/css/* stylesheets"
    end

    task :js => :src do
      sh "cp #{ @source }/js/* javascripts"
    end

    task :fonts => :src do
      sh "cp -r #{ @source }/fonts media"
    end
  end
end