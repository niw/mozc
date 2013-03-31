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
    # NOTE For now, mozc_build.py checks these libraries are installed,
    # I don't know why we need these to build Mozc for Android though.
    "libibus-1.0-dev",
    "libzinnia-dev",
  ]:
    ensure  => latest,
    require => Exec["apt-get update"];
}

file {
  "/opt/android":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => 0755;
}

exec {
  "apt-get update":
    command => "/usr/bin/apt-get update";

  "download android-sdk":
    command => "/usr/bin/curl 'http://dl.google.com/android/android-sdk_r21.1-linux.tgz' | /bin/tar -x -z -C /opt/android",
    creates => "/opt/android/android-sdk-linux",
    user    => $user,
    require => [
      Package["curl"],
      File["/opt/android"]
    ];

  "update android-sdk":
    # NOTE -u to not use GUI, -t to exclude system-image but we need extra-android-support.
    command => "/opt/android/android-sdk-linux/tools/android update sdk -u -t platform,tool,platform-tool,extra-android-support",
    user    => $user,
    # Disable timeout, this command takes really long time at first run.
    timeout => 0,
    require => [
      Package["default-jdk"],
      Exec["download android-sdk"]
    ];

  "download android-ndk":
    command => "/usr/bin/curl 'http://dl.google.com/android/ndk/android-ndk-r8c-linux-x86.tar.bz2' | /bin/tar -x -j -C /opt/android",
    creates => "/opt/android/android-ndk-r8c",
    user    => $user,
    require => [
      Package["curl"],
      File["/opt/android"]
    ];
}
