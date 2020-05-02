plan nessusagent::agentinstall(
  TargetSpec           $targets,
  String               $action = "install",
  Optional[String]     $winsource = undef,
  Optional[String]     $winfilepath = undef,
  Optional[String]     $nixfilepath = undef,
  Optional[String]     $nixsource = undef,
  Optional[String]     $port = "443",
  Optional[String]     $host = "cloud.tenable.com",
  Optional[String]     $groups = undef,
  String               $key,
){
  
  /* if ! $nixsource and ! $nixfilepath and ! $winsource and ! $winfilepath {
    fail("Expects either a nix source and filepath, a windows source and filepath, or a source and filepath for both")
  } */
  
  run_plan(facts, targets => $targets)
  
  get_targets($targets).each |$target| {
    out::message($target.facts['os']['family'])
  }

  $centos_targets = get_targets($targets).filter |$centos| {$centos.facts['os']['name'] == 'CentOS'}
  $windows_targets = get_targets($targets).filter |$win| {$win.facts['os']['name'] == "windows"}

  if $nixsource and $nixfilepath {
   
   upload_file($nixsource, $nixfilepath, $centos_targets, "Uploading to... ${nixfilepath}")

   run_task(
     'nessusagent::nixinstall',
     $centos_targets,
     key => $key,
     host => $host,
     port => $port,
     nixfilepath => $nixfilepath,
     groups => $groups,
     action => $action)
 }
  
 if $winsource and $winfilepath{
    
  upload_file($winsource, $winfilepath, $windows_targets, "Uploading to... ${winfilepath}")

  run_task(
     'nessusagent::wininstall',
     $windows_targets,
     installfilepath => $winfilepath,
     #nessus_server => "$host:$port",
     key => $key,
     groups => $groups,
     action => $action)
 }
}
