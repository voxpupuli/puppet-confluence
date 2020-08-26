define confluence::conf (
  $value,
  $key = $name,
  $config_file = "${confluence::homedir}/confluence.cfg.xml",
) {
  require Class[confluence::install]

  $aug_path = "set /files${config_file}/confluence-configuration/properties/property[#attribute/name = \"${key}\"]/#text \"${value}\""

  augeas { "${config_file} - ${key}":
    lens    => 'Xml.lns',
    incl    => $config_file,
    onlyif  => "get /files${config_file}/confluence-configuration/setupStep/#text == complete",
    changes => [
      $aug_path,
    ],
  }

  if $confluence::manage_service {
    Augeas<| |> ~> Service['confluence']
  }
}
