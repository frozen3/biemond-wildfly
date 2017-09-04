#
# Executes an arbitrary JBoss-CLI command
#   `[node-type=node-name (/node-type=node-name)*] : operation-name ['('[name=value [, name=value]*]')'] [{header (;header)*}]`.
#   This define is a wrapper for `wildfly_cli` that defaults to your local Wildfly installation.
#
# @param command The actual command to execute.
# @param unless If this parameter is set, then this `cli` will only run if this command condition is met.
# @param onlyif If this parameter is set, then this `cli` will run unless this command condition is met.
define wildfly::cli(
  String $command = $title,
  Optional[String] $unless = undef,
  Optional[String] $onlyif = undef) {

  if $wildfly::secure_mgmt_api {
    $mgmt_port  = $wildfly::properties['jboss.management.https.port']
    $mgmt_protocol = 'https'
  }

  else {
    $mgmt_port = $wildfly::properties['jboss.management.http.port']
    $mgmt_protocol = 'http'
  }


  wildfly_cli { $title:
    command  => $command,
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::properties['jboss.bind.address.management'],
    port     => $mgmt_port,
    protocol => $mgmt_protocol,
    unless   => $unless,
    onlyif   => $onlyif,
    require  => Service['wildfly'],
  }

}
