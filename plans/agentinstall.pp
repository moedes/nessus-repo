plan nessusrepo::agentinstall(
  TargetSpec           $targets,
  Optional[String]     $winsource = undef,
  Optional[String]     $winfilepath = undef,
  Optional[String]     $nixfilepath = undef,
  Optional[String]     $nixsource = undef,
  Optional[String]     $port = "443",
  Optional[String]     $host = "cloud.tenable.com",
  String               $key,
){
  
  run_plan(facts, targets => $targets)
  
  $centos_targets = get_targets($targets).filter |$centos| {$centos.facts['os']['name'] == 'CentOS'}
  $windows_targets = get_targets($targets).filter |$win| {$win.facts['os']['name'] == "windows"}

 if $nixsource {
   
   upload_file($nixsource, $nixfilepath, $centos_targets, "Uploading to... ${nixfilepath}")

   run_task(
     'nessusrepo::nixinstall',
     $centos_targets,
     key => $key,
     host => $host,
     port => $port,
     nixfilepath => $nixfilepath)
 }
  
 if $winsource {
    
  upload_file($winsource, $winfilepath, $windows_targets, "Uploading to... ${winfilepath}")

  run_task(
     'nessusrepo::wininstall',
     $windows_targets,
     installfilepath => $winfilepath,
     #nessus_server => "$host:$port",
     key => $key)
 }
}
