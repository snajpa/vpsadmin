#!/usr/bin/php
<?php
/*
    ./cron_nonpayers.php

    vpsAdmin
    Web-admin interface for OpenVZ (see http://openvz.org)
    Copyright (C) 2008-2012 Pavel Snajdr
    Copyright (C) 2012 Jakub Skokan

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


include '/etc/vpsadmin/config.php';
session_start();
define ('CRON_MODE', true);
define ('DEMO_MODE', false);

// Include libraries
include WWW_ROOT.'lib/db.lib.php';
include WWW_ROOT.'lib/functions.lib.php';
include WWW_ROOT.'lib/transact.lib.php';
include WWW_ROOT.'lib/vps.lib.php';
include WWW_ROOT.'lib/members.lib.php';
include WWW_ROOT.'lib/networking.lib.php';
include WWW_ROOT.'lib/version.lib.php';
include WWW_ROOT.'lib/cluster.lib.php';
include WWW_ROOT.'lib/mail.lib.php';

$db = new sql_db (DB_HOST, DB_USER, DB_PASS, DB_NAME);

$nonpayers = "<table cellspacing=\"0\" cellpadding=\"6\" border=\"1\">\n";

$nonpayers .= "\t<tr>\n";
$nonpayers .= "\t\t<th>"._("Nickname")."</th>\n\t\t<th>"._("Expiration")."</th>\n\t\t<th>"._("Info")."</th>\n";
$nonpayers .= "\t</tr>\n";

$whereCond = "m_paid_until IS NOT NULL AND m_paid_until != '' AND ADDDATE(FROM_UNIXTIME(m_paid_until), INTERVAL 14 DAY) < NOW()";

while ($m = $db->find("members", $whereCond, "FROM_UNIXTIME(m_paid_until)")) {
	$member = member_load($m["m_id"]);
	
	$nonpayers .= "\t<tr>\n";
	$nonpayers .= "\t\t<td>".$member->m["m_nick"]."</td>\n";
	$nonpayers .= "\t\t<td>".strftime("%Y-%m-%d %H:%M", $member->m["m_paid_until"])." (".round(($member->m["m_paid_until"] - time()) / 60 / 60 / 24).")</td>\n";
	$nonpayers .= "\t\t<td>".$member->m["m_info"]."</td>\n";
	$nonpayers .= "\t</tr>\n";
}

$nonpayers .= "</table>\n";

$neverpaid = "<table cellspacing=\"0\" cellpadding=\"6\" border=\"1\">\n";
$neverpaid .= "\t<tr>\n";
$neverpaid .= "\t\t<th>"._("Nickname")."</th>\n\t\t<th>"._("Created")."</th>\n\t\t<th>"._("Info")."</th>\n";
$neverpaid .= "\t</tr>\n";

$whereCond = "(m_paid_until IS NULL OR m_paid_until = '') AND ADDDATE(FROM_UNIXTIME(m_created), INTERVAL 7 DAY) < NOW()";

while ($m = $db->find("members", $whereCond, "m_created")) {
	$member = member_load($m["m_id"]);
	
	$neverpaid .= "\t<tr>\n";
	$neverpaid .= "\t\t<td>".$member->m["m_nick"]."</td>\n";
	$neverpaid .= "\t\t<td>".strftime("%Y-%m-%d %H:%M", $member->m["m_created"])." (".round(($member->m["m_created"] - time()) / 60 / 60 / 24).")</td>\n";
	$neverpaid .= "\t\t<td>".$member->m["m_info"]."</td>\n";
	$neverpaid .= "\t</tr>\n";
}

$neverpaid .= "</table>\n";

if(empty($neverpaid) && empty($nonpayers))
	die;

$to = $cluster_cfg->get("mailer_nonpayers_mail");
$subject = $cluster_cfg->get("mailer_tpl_nonpayers_subj");

$content = $cluster_cfg->get("mailer_tpl_nonpayers");
$content = str_replace("%never_paid%", $neverpaid, $content);
$content = str_replace("%nonpayers%", $nonpayers, $content);

send_mail($to, $subject, $content, array(), array(), true);
