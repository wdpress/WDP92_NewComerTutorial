execute 'install bundle gems' do
  command 'bundle install'
  cwd '/var/www/todo'
end

execute 'migrate database' do
  command 'bin/rake db:migrate'
  cwd '/var/www/todo'
end

execute 'install npm modules' do
  command <<-EOS
    npm install
    npm install -g browserify
    npm run build
  EOS
  cwd '/var/www/todo'
end

service 'todo_app' do
  action [:start, :enable]
end

package 'nginx'
service 'nginx' do
  action [:start, :enable]
end

file '/etc/nginx/conf.d/proxy.conf' do
  content <<-EOS
  server {
      listen 80;
      server_name wdp4.com;
      location / {
          proxy_pass http://192.168.80.10:3000;
      }
  }
  EOS
  owner 'nginx'
  group 'nginx'
  notifies :reload, 'service[nginx]'
end
