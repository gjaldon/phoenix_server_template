default['phoenix-git']['app_name'] = "app"
default['phoenix-git']['app_port_1'] = "8080"
default['phoenix-git']['app_port_2'] = "8081"
default['phoenix-git']['mix_env'] = "prod"

# Postgres DB attributes
default['phoenix-git']['db_name'] = "postgres_prod"
default['phoenix-git']['db_connection'] = {
  :host      => "127.0.0.1",
  :port      => 5432,
  :username  => "postgres",
  :password  => "test"
}
