node default {
}

node 'master.puppet' {

include nginx

nginx::resource::server { 'static':
  listen_port => 80,
  proxy => 'http://192.168.33.11:80',
  }

nginx::resource::server { 'dynamic':
  listen_port => 81,
  proxy => 'http://192.168.33.12:80',
  }


exec { 'selinux_to_permissive':
  command     => 'setenforce 0',
  path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
  user       => 'root',
  }

exec { 'reboot_nginx':
  command     => 'systemctl restart nginx',
  path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
  user => 'root',
  }
}

node 'slave1.puppet' {
   class { 'apache': }

   file { '/root/README':
      ensure => absent,
      }

   file { '/var/www/html/index.html':
      ensure => file,
      source => 'https://github.com/AlexeyRusak/devops-hometasks/blob/master/task-03/01/index.html',
      replace => false,
      }
}

node 'slave2.puppet' {
   class { 'apache::mod::php': }

   class { 'php': }

   file { '/root/README':
      ensure => absent,
      }

   file { '/var/www/html/index.php':
      ensure => file,
      source => 'https://github.com/AlexeyRusak/devops-hometasks/blob/master/task-03/01/index.php',
      replace => false,
      }
}

node 'mineserver.puppet' {

 package {'java-17-openjdk':
  ensure => installed,
}

 file {'/opt/minecraft':
  ensure => directory,
}

 file {'/opt/minecraft/eula.txt':
  content => 'eula=true',
}

file { '/opt/minecraft/server.jar':
  ensure => file,
  source => 'https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar',
  replace => false,
     }

  file { '/etc/systemd/system/minecraft.service':
    owner => 'root',
    group => 'root',
    ensure => file,
    mode   => '0644',
    source => 'https://github.com/AlexeyRusak/devops-hometasks/tree/master/puppet/production/modules/minecraft/files/minecraft.sevice',
    replace => false,
    }


 ~> service { 'minecraft':
        ensure => running,
        enable => true
   }
}
