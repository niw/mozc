$user  = "vagrant"
$group = "vagrant"

package {
  [
    "git",
    "subversion",
    "curl",
    "default-jdk",
    "ant",
    "gcc",
    "g++",
    "make",
    "python",
    # For now, mozc_build.py checks these libraries are installed,
    # I don't know why we need these to build Mozc for Android though.
    "libibus-1.0-dev",
    "libzinnia-dev",
    # Interact with android command, which is now asking license agreement. Sigh.
    "expect"
  ]:
    ensure => latest,
    require => Exec["apt-get update"];
}

file {
  "/opt/android":
    ensure => directory,
    owner => $user,
    group => $group,
    mode => 0755;
}

exec {
  "apt-get update":
    command => "/usr/bin/apt-get update";

  "download android-sdk":
    command => "/usr/bin/curl 'http://dl.google.com/android/android-sdk_r22.6.2-linux.tgz' | /bin/tar -x -z -C /opt/android",
    creates => "/opt/android/android-sdk-linux",
    user => $user,
    require => [
      Package["curl"],
      File["/opt/android"]
    ];

  "update android-sdk":
    # Run android update command on expect to answer license agreement.
    # NOTE -u to not use GUI, -t to install minimum requirements.
    command => "/usr/bin/expect -c 'set timeout -1; spawn /opt/android/android-sdk-linux/tools/android update sdk -u -t tool,platform-tool,build-tools-19.0.3,android-18,extra-android-support; while { true } { expect \"y/n\" { send \"y\\r\" } eof { catch wait r; exit [lindex \$r 3] }; }'",
    user => $user,
    # Disable timeout, this command takes really long time at first run.
    timeout => 0,
    require => [
      Package["default-jdk", "expect"],
      Exec["download android-sdk"]
    ];

  "download android-ndk":
    command => "/usr/bin/curl 'http://dl.google.com/android/ndk/android-ndk-r9d-linux-x86.tar.bz2' | /bin/tar -x -j -C /opt/android",
    creates => "/opt/android/android-ndk-r9d",
    user => $user,
    require => [
      Package["curl"],
      File["/opt/android"]
    ];
}
