role :app, %w{crutter crutter2}
role :web, %w{crutter crutter2}
role :db,  %w{crutter crutter2}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/crutter'

set :default_env, {
  rbenv_root: "/home/ec2-user/.rbenv",
  path: "/home/ec2-user/.rbenv/shims:/home/ec2-user/.rbenv/bin:$PATH",
}
