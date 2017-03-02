<?php

function outage_entities_to_array ($outage) {
	$ret = array(
		'cluster' => false,
		'environments' => array(),
		'locations' => array(),
		'nodes' => array(),
	);
	$extra = array();

	foreach ($outage->entity->list() as $ent) {
		switch ($ent->name) {
		case 'Cluster':
			$ret['cluster'] = true;
			break;

		case 'Environment':
			$ret['environments'][] = $ent->entity_id;
			break;

		case 'Location':
			$ret['locations'][] = $ent->entity_id;
			break;

		case 'Node':
			$ret['nodes'][] = $ent->entity_id;
			break;

		default:
			$extra[] = $ent->name;
		}
	}

	$ret['additional'] = implode(',', $extra);

	return $ret;
}

function outage_report_form () {
	global $xtpl, $api;

	$input = $api->outage->create->getParameters('input');

	$xtpl->table_title(_('Outage Report'));

	$xtpl->form_create('?page=outage&action=report', 'post');

	$xtpl->form_add_input(_('Date and time').':', 'text', '30', 'begins_at', date('Y-m-d H:i'));
	$xtpl->form_add_number(_('Duration').':', 'duration', post_val('duration'), 0, 999999, 1, 'minutes');
	$xtpl->form_add_checkbox(_('Planned').':', 'planned', '1', post_val('planned'));
	api_param_to_form('type', $input->type);

	$xtpl->form_add_checkbox(_('Cluster-wide').':', 'cluster_wide', '1', post_val('cluster_wide'));
	$xtpl->form_add_select(
		_('Environments').':', 'environments[]',
		resource_list_to_options($api->environment->list(), 'id', 'label', false),
		post_val('environments'), '', true, 5
	);
	$xtpl->form_add_select(
		_('Locations').':', 'locations[]',
		resource_list_to_options($api->location->list(), 'id', 'label', false),
		post_val('locations'), '', true, 5
	);
	$xtpl->form_add_select(
		_('Nodes').':', 'nodes[]',
		resource_list_to_options($api->node->list(), 'id', 'domain_name', false),
		post_val('nodes'), '', true, 20
	);
	$xtpl->form_add_input(
		_('Additional systems').':', 'text', '70', 'entities', post_val('entities'),
		_('Comma separated list of other affected systems')
	);

	foreach ($api->language->list() as $lang) {
		$xtpl->form_add_input(
			$lang->label.' '._('summary').':', 'text', '70', $lang->code.'_summary',
			post_val($lang->code.'_summary')
		);
		$xtpl->form_add_textarea(
			$lang->label.' '._('description').':', 70, 8, $lang->code.'_description',
			post_val($lang->code.'_description')
		);
	}

	$xtpl->form_add_select(
		_('Handled by').':', 'handlers[]',
		resource_list_to_options($api->user->list(array('admin' => true)), 'id', 'full_name', false),
		post_val('handlers'), '', true, 10
	);

	$xtpl->form_out(_('Continue'));
}

function outage_edit_form ($id) {
	global $xtpl, $api;

	$outage = $api->outage->show($id);

	$xtpl->sbar_add(_('Back'), '?page=outage&action=show&id='.$outage->id);

	$xtpl->title(_('Outage').' #'.$outage->id);
	$xtpl->table_title(_('Edit affected entities and handlers'));
	$xtpl->form_create('?page=outage&action=edit&id='.$outage->id, 'post');

	$ents = outage_entities_to_array($outage);

	$xtpl->form_add_checkbox(
		_('Cluster-wide').':', 'cluster_wide', '1',
		post_val('cluster_wide', $ents['cluster'])
	);
	$xtpl->form_add_select(
		_('Environments').':', 'environments[]',
		resource_list_to_options($api->environment->list(), 'id', 'label', false),
		post_val('environments', $ents['environments']), '', true, 5
	);
	$xtpl->form_add_select(
		_('Locations').':', 'locations[]',
		resource_list_to_options($api->location->list(), 'id', 'label', false),
		post_val('locations', $ents['locations']), '', true, 5
	);
	$xtpl->form_add_select(
		_('Nodes').':', 'nodes[]',
		resource_list_to_options($api->node->list(), 'id', 'domain_name', false),
		post_val('nodes', $ents['nodes']), '', true, 20
	);
	$xtpl->form_add_input(
		_('Additional systems').':', 'text', '70', 'entities',
		post_val('entities', $ents['additional']),
		_('Comma separated list of other affected systems')
	);

	$xtpl->form_add_select(
		_('Handled by').':', 'handlers[]',
		resource_list_to_options($api->user->list(array('admin' => true)), 'id', 'full_name', false),
		post_val('handlers', array_map(
			function ($h) { return $h->user_id; },
			$outage->handler->list()->asArray()
		)), '', true, 10
	);

	$xtpl->form_out(_('Save'));
}

function outage_update_form ($id) {
	global $xtpl, $api;

	$input = $api->outage->create->getParameters('input');
	$outage = $api->outage->show($id);

	$xtpl->sbar_add(_('Back'), '?page=outage&action=show&id='.$outage->id);

	$xtpl->title(_('Outage').' #'.$id);
	$xtpl->table_title(_('Post update'));
	$xtpl->form_create('?page=outage&action=update&id='.$outage->id, 'post');

	$xtpl->form_add_input(
		_('Date and time').':', 'text', '30', 'begins_at',
		tolocaltz($outage->begins_at, 'Y-m-d H:i')
	);
	$xtpl->form_add_input(
		_('Finished at').':', 'text', '30', 'finished_at',
		$outage->finished_at ? tolocaltz($outage->finished_at, 'Y-m-d H:i') : ''
	);
	$xtpl->form_add_number(
		_('Duration').':', 'duration', post_val('duration', $outage->duration),
		0, 999999, 1, 'minutes'
	);
	api_param_to_form('type', $input->type, $outage->type);

	foreach ($api->language->list() as $lang) {
		$xtpl->form_add_input(
			$lang->label.' '._('summary').':', 'text', '70', $lang->code.'_summary',
			post_val($lang->code.'_summary')
		);
		$xtpl->form_add_textarea(
			$lang->label.' '._('description').':', 70, 8, $lang->code.'_description',
			post_val($lang->code.'_description')
		);
	}

	$xtpl->form_add_checkbox(
		_('Send mails').':', 'send_mail', '1',
		($_POST['state'] && !$_POST['send_mail']) ? false : true
	);

	$xtpl->form_out(_('Post update'));
}

function outage_details ($id) {
	global $xtpl, $api;

	if ($_SESSION['is_admin']) {
		$xtpl->sbar_add(_('Edit'), '?page=outage&action=edit&id='.$id);
		$xtpl->sbar_add(_('Post update'), '?page=outage&action=update&id='.$id);
	}

	$outage = $api->outage->show($id);
	$langs = $api->language->list();

	if ($_SESSION['is_admin'])
		$xtpl->form_create('?page=outage&action=set_state&id='.$id, 'post');

	$xtpl->title(_('Outage').' #'.$id);

	$xtpl->table_title(_('Status'));
	$xtpl->table_td(_('Affected VPS').':');

	if ($_SESSION['is_admin']) {
		if ($outage->state == 'staged') {
			$xtpl->table_td(_('Affected VPSes have not been checked yet.'));

		} else {
			$affected_vpses = $api->vps_outage->list(array(
				'outage' => $outage->id,
				'limit' => 0,
				'meta' => array(
					'count' => true,
				),
			));
			$affected_users = 0;

			if ($affected_vpses->getTotalCount()) {
				$affected_users = $api->user_outage->list(array(
					'outage' => $outage->id,
					'limit' => 0,
					'meta' => array(
						'count' => true,
					),
				))->getTotalCount();
			}

			$xtpl->table_td(
				$affected_vpses->getTotalCount().' '._('VPSes are affected by this outage.').
				"\n<br>\n".
				$affected_users.' '._('users are affected by this outage.')
			);
		}

	} else {
		$affected_vpses = $api->vps_outage->list(array(
			'outage' => $outage->id,
			'meta' => array(
				'includes' => 'vps',
			),
		));

		if ($affected_vpses->count()) {
			$s = '';
			if ($outage->state == 'closed'
				|| (strtotime($outage->begins_at) + $outage->duration) < time()
				|| ($outage->finished_at && strtotime($outage->finished_at) < time())
			) {
				$s .= '<strong>';
				$s .= _('This outage has been resolved and all systems should have recovered.');
				$s .= '</strong><br>';
			}

			$s .= implode("\n<br>\n", array_map(
				function ($outage_vps) {
					$v = $outage_vps->vps;
					return vps_link($v).' - '.$v->hostname;

				}, $affected_vpses->asArray()
			));

			$xtpl->table_td($s);

		} else {
			$xtpl->table_td('<strong>'._('You are not affected by this outage.').'</strong>');
		}
	}

	$xtpl->table_tr();
	$xtpl->table_out();

	$xtpl->table_title(_('Information'));
	$xtpl->table_td(_('Begins at').':');
	$xtpl->table_td(tolocaltz($outage->begins_at));
	$xtpl->table_tr();

	$xtpl->table_td(_('Duration').':');
	$xtpl->table_td($outage->duration.' '._('minutes'));
	$xtpl->table_tr();

	$xtpl->table_td(_('Planned').':');
	$xtpl->table_td(boolean_icon($outage->planned));
	$xtpl->table_tr();

	$xtpl->table_td(_('State').':');
	$xtpl->table_td($outage->state);
	$xtpl->table_tr();

	$xtpl->table_td(_('Type').':');
	$xtpl->table_td($outage->type);
	$xtpl->table_tr();

	$xtpl->table_td(_('Affected systems').':');
	$xtpl->table_td(implode("\n<br>\n", array_map(
		function ($ent) { return $ent->label; },
		$outage->entity->list()->asArray()
	)));
	$xtpl->table_tr();

	$summary = array();

	foreach ($langs as $lang) {
		$name = $lang->code.'_summary';

		if (!$outage->{$name})
			continue;

		$summary[] = '<strong>'.$lang->label.'</strong>: '.$outage->{$name};
	}

	$xtpl->table_td(_('Summary').':');
	$xtpl->table_td(implode("\n<br><br>\n", $summary));
	$xtpl->table_tr();

	$desc = array();

	foreach ($langs as $lang) {
		$name = $lang->code.'_description';

		if (!$outage->{$name})
			continue;

		$desc[] = '<strong>'.$lang->label.'</strong>: '.nl2br($outage->{$name});
	}

	$xtpl->table_td(_('Description').':');
	$xtpl->table_td(implode("\n<br><br>\n", $desc));
	$xtpl->table_tr();

	$xtpl->table_td(_('Handled by').':');
	$xtpl->table_td(implode(', ', array_map(
		function ($h) { return $h->full_name; },
		$outage->handler->list()->asArray()
	)));
	$xtpl->table_tr();

	if ($_SESSION['is_admin']) {
		$xtpl->form_add_select(_('State').':', 'state', array(
			'announce' => _('Announce'),
			'cancel' => _('Cancel'),
			'close' => _('Close'),
		), post_val('state'));

		$xtpl->form_add_checkbox(
			_('Send mails').':', 'send_mail', '1',
			($_POST['state'] && !$_POST['send_mail']) ? false : true
		);

		$xtpl->form_out(_('Change'));

	} else
		$xtpl->table_out();

	$xtpl->table_title(_('Updates'));
	$xtpl->table_add_category(_('Date'));
	$xtpl->table_add_category(_('Summary'));
	$xtpl->table_add_category(_('Reported by'));

	foreach ($api->outage_update->list(array('outage' => $outage->id)) as $update) {
		$xtpl->table_td(tolocaltz($update->created_at));

		$summary = array();

		foreach ($langs as $lang) {
			$name = $lang->code.'_summary';

			if (!$update->{$name})
				continue;

			$summary[] = '<strong>'.$lang->label.'</strong>: '.$update->{$name};
		}

		$xtpl->table_td(implode("\n<br>\n", $summary));
		$xtpl->table_td($update->reporter_name);

		$changes = array();
		$check = array('begins_at', 'finished_at', 'state', 'type', 'duration');

		foreach ($check as $p) {
			if ($update->{$p}) {
				switch ($p) {
				case 'begins_at':
					$changes[] = _("Begins at:").' '.tolocaltz($update->begins_at);
					break;

				case 'finished_at':
					$changes[] = _("Finished at:").' '.tolocaltz($update->finished_at);
					break;

				case 'state':
					$changes[] = _("State:").' '.$update->state;
					break;

				case 'type':
					$changes[] = _("Outage type:").' '.$update->type;
					break;

				case 'duration':
					$changes[] = _("Duration:").' '.$update->duration.' '._('minutes');
					break;
				}
			}
		}

		$desc = array();

		foreach ($langs as $lang) {
			$name = $lang->code.'_description';

			if (!$update->{$name})
				continue;

			$desc[] = '<strong>'.$lang->label.'</strong>: '.nl2br($update->{$name});
		}

		$str = implode("\n<br><br>\n", array_filter(array(
			implode("\n<br>\n", $changes),
			implode("\n<br><br>\n", $desc),
		)));

		$xtpl->table_tr();

		if ($str) {
			$xtpl->table_td($str, false, false, 3);
			$xtpl->table_tr();
		}
	}

	$xtpl->table_out();
}

function outage_list () {
	global $xtpl, $api;

	$xtpl->title(_('Outage list'));
	$xtpl->table_title(_('Filters'));
	$xtpl->form_create('', 'get');

	$xtpl->table_td(_("Limit").':'.
		'<input type="hidden" name="page" value="outage">'.
		'<input type="hidden" name="action" value="list">'
	);
	$xtpl->form_add_input_pure('text', '40', 'limit', get_val('limit', '25'), '');
	$xtpl->table_tr();

	$input = $api->outage->list->getParameters('input');

	$xtpl->form_add_select(_('Planned').':', 'planned', array(
		'' => '---',
		'yes' => _('Planned'),
		'no' => _('Unplanned'),
	), get_val('planned'));
	api_param_to_form('state', $input->state, null, null, true);
	api_param_to_form('type', $input->type, null, null, true);
	$xtpl->form_add_select(_('Affects me?'), 'affected', array(
		'' => '---',
		'yes' => _('Yes'),
		'no' => _('No'),
	), get_val('affected'));

	$xtpl->form_out(_('Show'));

	$xtpl->table_add_category(_('Date'));
	$xtpl->table_add_category(_('Duration'));
	$xtpl->table_add_category(_('Planned'));
	$xtpl->table_add_category(_('State'));
	$xtpl->table_add_category(_('Systems'));
	$xtpl->table_add_category(_('Type'));
	$xtpl->table_add_category(_('Reason'));

	if ($_SESSION['is_admin']) {
		$xtpl->table_add_category(_('Users'));
		$xtpl->table_add_category(_('VPS'));

	} else
		$xtpl->table_add_category(_('Affects me?'));

	$xtpl->table_add_category('');

	$params = array(
		'limit' => get_val('limit', 25),
	);

	foreach (array('planned', 'affected') as $v) {
		if ($_GET[$v] === 'yes')
			$params[$v] = true;

		elseif ($_GET[$v] === 'no')
			$params[$v] = false;
	}

	foreach (array('state', 'type') as $v) {
		if ($_GET[$v])
			$params[$v] = $_GET[$v];
	}

	$outages = $api->outage->list($params);

	foreach ($outages as $outage) {
		$xtpl->table_td(tolocaltz($outage->begins_at, 'Y-m-d H:i'));
		$xtpl->table_td($outage->duration, false, true);
		$xtpl->table_td(boolean_icon($outage->planned));
		$xtpl->table_td($outage->state);
		$xtpl->table_td(implode(', ', array_map(
			function ($v) { return $v->label; },
			$outage->entity->list()->asArray()
		)));
		$xtpl->table_td($outage->type);
		$xtpl->table_td($outage->en_summary);

		if ($_SESSION['is_admin']) {
			if ($outage->state == 'staged') {
				$xtpl->table_td('-', false, true);
				$xtpl->table_td('-', false, true);

			} else {
				$xtpl->table_td($outage->affected_user_count, false, true);
				$xtpl->table_td($outage->affected_vps_count, false, true);
			}

		} else
			$xtpl->table_td(boolean_icon($outage->affected));

		$xtpl->table_td('<a href="?page=outage&action=show&id='.$outage->id.'"><img src="template/icons/m_edit.png"  title="'. _("Details") .'" /></a>');

		$xtpl->table_tr();
	}

	$xtpl->table_out();
}