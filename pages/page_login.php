<?php
/*
    ./pages/page_login.php

    vpsAdmin
    Web-admin interface for OpenVZ (see http://openvz.org)
    Copyright (C) 2008-2009 Pavel Snajdr, snajpa@snajpa.net

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

if ($_GET["action"] == 'login') {
	$access_url = $_SESSION["access_url"];
	
	if (($_REQUEST["passwd"] != '') && ($_REQUEST["username"])) {

		$sql = 'SELECT * FROM members WHERE m_pass = "'
				 . $db->check( md5($_REQUEST["username"] . $_REQUEST["passwd"]) )
				 . '" AND m_nick = "' . $db->check($_REQUEST["username"]) . '" AND m_state != "deleted"';

		if ($result = $db->query($sql)) {

			if ($member = $db->fetch_array($result)) {

			session_destroy();
			session_start();

			$_SESSION["logged_in"] = true;
			$_SESSION["member"] = $member;
			$_SESSION["is_user"] =       ($member["m_level"] >= PRIV_USER) ?       true : false;
			$_SESSION["is_poweruser"] =  ($member["m_level"] >= PRIV_POWERUSER) ?  true : false;
			$_SESSION["is_admin"] =      ($member["m_level"] >= PRIV_ADMIN) ?      true : false;
			$_SESSION["is_superadmin"] = ($member["m_level"] >= PRIV_SUPERADMIN) ? true : false;

			$xtpl->perex(_("Welcome, ").$member["m_nick"],
					_("Login successful <br /> Your privilege level: ")
					. $cfg_privlevel[$member["m_level"]]);
			
			$_member = member_load($member["m_id"]);
			$_member->touch_activity();
			
			if($access_url
				&& strpos($access_url, "?page=login&action=login") === false
				&& strpos($access_url, "?page=jumpto") === false)
				redirect($access_url);
				
			elseif ($_SESSION["is_admin"])
				redirect('?page=cluster');
				
			else
				redirect('?page=');

			} else $xtpl->perex(_("Error"), _("Wrong username or password"));
		} else $xtpl->perex(_("Error"), _("Wrong username or password"));
	} else $xtpl->perex(_("Error"), _("Wrong username or password"));
}

if ($_GET["action"] == 'logout') {

	$_SESSION["logged_in"] = false;
	unset($_SESSION["member"]);

	$xtpl->perex(_("Goodbye"), _("Logout successful"));

	session_destroy();
}

if ($_SESSION["is_admin"] && ($_GET["action"] == 'drop_admin')) {
	$_SESSION["context_switch"] = true;
	$_SESSION["original_admin"] = $_SESSION;
	$_SESSION["is_admin"] = false;
	
	$xtpl->perex(_("Dropped admin privileges"), '');
	redirect($_GET["next"]);
}

if ($_SESSION["is_admin"] && ($_GET["action"] == 'switch_context') && isset($_GET["m_id"])) {

	$sql = 'SELECT * FROM members WHERE m_id="' . $db->check($_GET["m_id"]) . '"';
	$admin = $_SESSION;

	if ($result = $db->query($sql)) {

		if ($member = $db->fetch_array($result)) {

			session_destroy(); // toms
			session_start(); // toms

			$_SESSION["logged_in"] = true;
			$_SESSION["member"] = $member;
			$_SESSION["is_user"] =       ($member["m_level"] >= PRIV_USER) ?       true : false;
			$_SESSION["is_poweruser"] =  ($member["m_level"] >= PRIV_POWERUSER) ?  true : false;
			$_SESSION["is_admin"] =      ($member["m_level"] >= PRIV_ADMIN) ?      true : false;
			$_SESSION["is_superadmin"] = ($member["m_level"] >= PRIV_SUPERADMIN) ? true : false;
			
			$_SESSION["context_switch"] = true;
			$_SESSION["original_admin"] = $admin;

			$xtpl->perex(_("Change to ").$member["m_nick"],
					_(" successful <br /> Your privilege level: ")
					. $cfg_privlevel[$member["m_level"]]);

			$_member = member_load($member["m_id"]);
			$_member->touch_activity();
			
			redirect($_GET["next"]);

		} else $xtpl->perex(_("Error"), _("Wrong username or password"));
	} else $xtpl->perex(_("Error"), _("Wrong username or password"));
}

if ($_GET["action"] == "regain_admin" && $_SESSION["context_switch"]) {
	$admin = $_SESSION["original_admin"];
	
	session_destroy();
	session_start();
		
	$_SESSION = $admin;
	
	redirect($_GET["next"]);
}
