class lustre_client (
  $mount_options = '',
  ) {

    package { 'lustre-client':
        ensure => 'present',
    }

    package { 'lustre-client-modules':
        ensure => 'present',
    }

    #file { 'lustre.conf':
    #    name   => '/etc/modprobe.d/lustre.conf',
        #source => 'puppet:///modules/lustre/lustre.ib-client.conf',
    #    content => template("lustre/lustre.conf"),
    #}

    #file { 'lnet.rc':
    #    name   => '/etc/init.d/lnet',
    #    mode   => '0755',
    #    source => 'puppet:///modules/lustre/lnet.rc',
    #}

    #file { '/etc/rc.local.hcc.d/lustre':
    #    ensure => 'present',
    #    owner  => 'root',
    #    group  => 'root',
    #    mode   => '0750',
    #    source => 'puppet:///modules/lustre/lustre.rc.local',
    #}

    service { 'lnet':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => [
            Package['lustre-client-modules'],
            Package['lustre-client'],
    #        File['lnet.rc'],
    #        File['lustre.conf'],
        ],
    }

    file { '/lustre':
        ensure => directory,
        path   => '/lustre',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/work':
        ensure  => link,
        target  => '/lustre/work',
    }

    mount { 'mds1':
        name    => "/lustre",
        ensure  => mounted,
        device  => 'mds1.sandhills.hcc.unl.edu@tcp:/SHlustre',
        fstype  => 'lustre',
        options => 'defaults,_netdev,localflock',
        dump    => 0,
        pass    => 0,
        remounts  => true,
        target  => '/etc/fstab',
    }
}
