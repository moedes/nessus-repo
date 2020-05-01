plan nessusagent::agentinstall(
  TargetSpec           $targets,
  Optional[String]     $winsource = undef,
  Optional[String]     $winfilepath = undef,
  Optional[String]     $nixfilepath = undef,
  Optional[String]     $nixsource = undef,
  Optional[String]     $port = "443",
  Optional[String]     $host = "cloud.tenable.com",
  String               $key,
){
  
  if ! $nixsource and ! $nixfilepath and ! $winsource and ! $winfilepath {
    fail("Expects either a nix source and filepath, a windows source and filepath, or a source and filepath for both")
  }
  
  run_plan(facts, targets => $targets)
  
  $centos_targets = get_targets($targets).filter |$centos| {$centos.facts['os']['name'] == 'CentOS'}
  $windows_targets = get_targets($targets).filter |$win| {$win.facts['os']['name'] == "windows"}

  if $nixsource and $nixfilepath {
   
    upload_file($nixsource, $nixfilepath, $centos_targets, "Uploading to... ${nixfilepath}")

    run_task(
      'nessusagent::nixinstall',
      $centos_targets,
      key => $key,
      nixfilepath => $nixfilepath
    )
  }
  
  if $winsource and $winfilepath {
    
    upload_file($winsource, $winfilepath, $windows_targets, "Uploading to... ${winfilepath}")

    run_task(
      'nessusagent::wininstall',
      $windows_targets,
      installfilepath => $winfilepath,
      key => $key,
      server => "$host":"port"
    )
  }
}
