name "myroku_app"
description "myroku app"
run_list [ "recipe[base]", "recipe[nginx]", "recipe[gitolite]" ]
