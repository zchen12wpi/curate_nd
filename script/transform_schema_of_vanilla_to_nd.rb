module TransformSchemaOfVanillaToNd
  module_function
  def call
    [
      "ALTER TABLE `users` ADD COLUMN `username` varchar(255);",
      "CREATE INDEX users_username ON users (username) USING BTREE;",
      "UPDATE `users` SET `username` = 'cdeluca1' WHERE `email` = 'cdeluca1@nd.edu'",
      "UPDATE `users` SET `username` = 'jfriesen' WHERE `email` = 'jeremy.n.friesen@gmail.com'"
    ].each do |sql_command|
      ActiveRecord::Base.connection.execute(sql_command)
    end
  end
end

TransformSchemaOfVanillaToNd.call
