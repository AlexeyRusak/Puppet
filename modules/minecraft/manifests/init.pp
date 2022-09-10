class minecraft {
  package {'java-17-openjdk':
    ensure => installed
    }

 file {'/opt/minecraft':
   ensure => directory
   }

file {'/opt/minecraft/eula.txt':
  ensure => file,
  content => 'eula=true'
     }
     

file { '/opt/minecraft/server.jar':
  ensure => file,
  source => 'https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar',
  replace => false,
     }

file {'/etc/systemd/system/minecraft.service':
   ensure => file,
   source => 'puppet:///modules/minecraft/minecraft.service'
   }

 ~> service { 'minecraft':
        ensure => running,
        enable => true
   }
}
