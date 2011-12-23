#!/usr/bin/php
<?php
// vim: set foldmethod=indent:

?>
<?php echo '<'.'?xml version="1.0"?'.'>'; ?>

<?php 

$data = array(
	'host_name' => 'template-catalyst',
	'host_group' => 'Templates',

	'snmp_community' => 'public',

	'port_list' => array(
		/*'2' => array(
				'short_name' => 'fa0/2'
			),*/
	),
);

$fp = fopen('php://stdin', 'r');

while($_row = fgets($fp)) {
	$row = trim($_row);
	
	// search for name
	if(strpos($row, 'SNMPv2-SMI::mib-2.47.1.1.1.1.13.1 ') === 0) {
		list($skip, $name ) = explode('STRING: ', $row);
		$name = substr($name, 1, -1);
		if(!empty($name)) {
			$data['host_name'] = 'template-'.$name;
		}else{
			_log('WARNING: cannot parse short device name');
		}
	}

	// search for port description
	if( strpos($row, 'IF-MIB::ifDescr.') === 0) {
		if(preg_match('/^IF-MIB::ifDescr.(\d+) = STRING: (.*)$/', $row, $m)) {
			$data['port_list'] [$m[1]] ['name'] = $m[2];
			$data['port_list'] [$m[1]] ['short_name'] = $m[2];
		}else{
			_log('WARNING: cannot parse device description: '.$row);
		}
	}


}

echo render($data);


function _log($msg) // {{{
{
	static $stderr_fd = null;
	if( $stderr_fd === null) {
		if( ! $stderr_fd = fopen('php://stderr', 'w') ) {
			echo "Could not open stderr";
			exit(-1);
		}
	}
	fputs($stderr_fd, $msg."\n");
} // }}}
 
function render($data)
{
	extract($data);
	ob_start();
?>
<!-- vim: set foldmethod=indent: -->
<zabbix_export version="1.0" date="04.01.10" time="18.23">
	<hosts>
		<host name="<?= $host_name; ?>">
			<useip>0</useip>
			<dns></dns>
			<ip></ip>
			<port>10050</port>
			<status>3</status>
			<groups>
				<group><?= $host_group; ?></group>
			</groups>
			<items>
				<item type="3" key="icmpping" value_type="0">
					<description>ping</description>
					<ipmi_sensor></ipmi_sensor>
					<delay>30</delay>
					<history>90</history>
					<trends>365</trends>
					<status>0</status>
					<units></units>
					<multiplier>0</multiplier>
					<delta>0</delta>
					<formula>1</formula>
					<lastlogsize>0</lastlogsize>
					<logtimefmt></logtimefmt>
					<delay_flex></delay_flex>
					<params></params>
					<trapper_hosts></trapper_hosts>
					<snmp_community><?= $snmp_community; ?></snmp_community>
					<snmp_oid>interfaces.ifTable.ifEntry.ifInOctets.1</snmp_oid>
					<snmp_port>161</snmp_port>
					<snmpv3_securityname></snmpv3_securityname>
					<snmpv3_securitylevel>0</snmpv3_securitylevel>
					<snmpv3_authpassphrase></snmpv3_authpassphrase>
					<snmpv3_privpassphrase></snmpv3_privpassphrase>
				</item>
				<item type="3" key="icmppingsec" value_type="0">
					<description>ping time</description>
					<ipmi_sensor></ipmi_sensor>
					<delay>30</delay>
					<history>90</history>
					<trends>365</trends>
					<status>0</status>
					<units></units>
					<multiplier>0</multiplier>
					<delta>0</delta>
					<formula>1</formula>
					<lastlogsize>0</lastlogsize>
					<logtimefmt></logtimefmt>
					<delay_flex></delay_flex>
					<params></params>
					<trapper_hosts></trapper_hosts>
					<snmp_community><?= $snmp_community; ?></snmp_community>
					<snmp_oid>interfaces.ifTable.ifEntry.ifInOctets.1</snmp_oid>
					<snmp_port>161</snmp_port>
					<snmpv3_securityname></snmpv3_securityname>
					<snmpv3_securitylevel>0</snmpv3_securitylevel>
					<snmpv3_authpassphrase></snmpv3_authpassphrase>
					<snmpv3_privpassphrase></snmpv3_privpassphrase>
				</item>
				<?php foreach($port_list as $pid => $pdesc) { ?>

					<item type="4" key="ifAdminStatus.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> admin status</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>0</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifAdminStatus.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>admin</application>
							<application>port status</application>
						</applications>
					</item>
					<item type="4" key="ifInErrors.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> input errors</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>1</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifInErrors.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>health</application>
						</applications>
					</item>
					<item type="4" key="ifInOctets.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> input rate</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>1</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifInOctets.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>port rate</application>
						</applications>
					</item>
					<item type="4" key="ifOperStatus.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> operStatus</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>0</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifOperStatus.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>port status</application>
						</applications>
					</item>
					<item type="4" key="ifOutErrors.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> output errors</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>1</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifOutErrors.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>health</application>
						</applications>
					</item>
					<item type="4" key="ifOutOctets.<?= $pid; ?>" value_type="3">
						<description><?= $pdesc['short_name']; ?> output rate</description>
						<ipmi_sensor></ipmi_sensor>
						<delay>10</delay>
						<history>90</history>
						<trends>365</trends>
						<status>0</status>
						<units></units>
						<multiplier>0</multiplier>
						<delta>1</delta>
						<formula>1</formula>
						<lastlogsize>0</lastlogsize>
						<logtimefmt></logtimefmt>
						<delay_flex></delay_flex>
						<params></params>
						<trapper_hosts></trapper_hosts>
						<snmp_community><?= $snmp_community; ?></snmp_community>
						<snmp_oid>IF-MIB::ifOutOctets.<?= $pid; ?></snmp_oid>
						<snmp_port>161</snmp_port>
						<snmpv3_securityname></snmpv3_securityname>
						<snmpv3_securitylevel>0</snmpv3_securitylevel>
						<snmpv3_authpassphrase></snmpv3_authpassphrase>
						<snmpv3_privpassphrase></snmpv3_privpassphrase>
						<applications>
							<application>port rate</application>
						</applications>
					</item>

				<?php } ?>

				<item type="4" key="sysDescr.0" value_type="4">
					<description>system description</description>
					<ipmi_sensor></ipmi_sensor>
					<delay>3600</delay>
					<history>90</history>
					<trends>0</trends>
					<status>0</status>
					<units></units>
					<multiplier>0</multiplier>
					<delta>0</delta>
					<formula>1</formula>
					<lastlogsize>0</lastlogsize>
					<logtimefmt></logtimefmt>
					<delay_flex></delay_flex>
					<params></params>
					<trapper_hosts></trapper_hosts>
					<snmp_community><?= $snmp_community; ?></snmp_community>
					<snmp_oid>SNMPv2-MIB::sysDescr.0</snmp_oid>
					<snmp_port>161</snmp_port>
					<snmpv3_securityname></snmpv3_securityname>
					<snmpv3_securitylevel>0</snmpv3_securitylevel>
					<snmpv3_authpassphrase></snmpv3_authpassphrase>
					<snmpv3_privpassphrase></snmpv3_privpassphrase>
					<applications>
						<application>information</application>
					</applications>
				</item>
			</items>
			<triggers><?php foreach($port_list as $pid => $pdesc) { ?>
					
					<trigger>
						<description><?= $pdesc['short_name']; ?> input errors</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifInErrors.<?= $pid; ?>.last(0)}&gt;10</expression>
						<url></url>
						<status>0</status>
						<priority>3</priority>
						<comments></comments>
					</trigger>
					<trigger>
						<description><?= $pdesc['short_name']; ?> output errors</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifOutErrors.<?= $pid; ?>.last(0)}&gt;10</expression>
						<url></url>
						<status>0</status>
						<priority>3</priority>
						<comments></comments>
					</trigger>
					<trigger>
						<description><?= $pdesc['short_name']; ?> input rate threshold exceeded</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifInOctets.<?= $pid; ?>.avg(#5)}&gt;2000</expression>
						<url></url>
						<status>0</status>
						<priority>2</priority>
						<comments></comments>
					</trigger>
					<trigger>
						<description><?= $pdesc['short_name']; ?> output rate threshold</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifOutOctets.<?= $pid; ?>.avg(#5)}&gt;2000</expression>
						<url></url>
						<status>0</status>
						<priority>2</priority>
						<comments></comments>
					</trigger>
					<trigger>
						<description><?= $pdesc['short_name']; ?> administratively down</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifAdminStatus.<?= $pid; ?>.last(0)}=2</expression>
						<url></url>
						<status>0</status>
						<priority>1</priority>
						<comments></comments>
					</trigger>
					<trigger>
						<description><?= $pdesc['short_name']; ?> down</description>
						<type>0</type>
						<expression>{{HOSTNAME}:ifOperStatus.<?= $pid; ?>.last(0)}=2</expression>
						<url></url>
						<status>0</status>
						<priority>1</priority>
						<comments></comments>
					</trigger>
			<?php } ?></triggers>
			<graphs><?php foreach($port_list as $pid => $pdesc) { ?>

					<graph name="<?= $pdesc['short_name']; ?> load" width="900" height="200">
						<yaxistype>2</yaxistype>
						<show_work_period>0</show_work_period>
						<show_triggers>0</show_triggers>
						<graphtype>0</graphtype>
						<yaxismin>0.0000</yaxismin>
						<yaxismax>100.0000</yaxismax>
						<show_legend>0</show_legend>
						<show_3d>0</show_3d>
						<percent_left>0.0000</percent_left>
						<percent_right>0.0000</percent_right>
						<graph_elements>
							<graph_element item="{HOSTNAME}:ifOutOctets.<?= $pid; ?>">
								<drawtype>0</drawtype>
								<sortorder>0</sortorder>
								<color>0000CC</color>
								<yaxisside>0</yaxisside>
								<calc_fnc>2</calc_fnc>
								<type>0</type>
								<periods_cnt>5</periods_cnt>
							</graph_element>
							<graph_element item="{HOSTNAME}:ifInOctets.<?= $pid; ?>">
								<drawtype>1</drawtype>
								<sortorder>0</sortorder>
								<color>009900</color>
								<yaxisside>0</yaxisside>
								<calc_fnc>2</calc_fnc>
								<type>0</type>
								<periods_cnt>5</periods_cnt>
							</graph_element>
						</graph_elements>
					</graph>
			<?php } ?></graphs>
		</host>
	</hosts>
	<dependencies><?php foreach($port_list as $pid => $pdesc) { ?>

		<dependency description="<?= $host_name; ?>:<?= $pdesc['short_name']; ?> down">
			<depends><?= $host_name; ?>:<?= $pdesc['short_name']; ?> administratively down</depends>
		</dependency>
	<?php } ?></dependencies>
</zabbix_export>
<?php 

	return ob_get_clean();
} // ~ render

?>

