<?php
/**
 * @file
 * datasource.features.inc
 */

/**
 * Implements hook_views_api().
 */
function datasource_views_api() {
  return array("version" => "3.0");
}

/**
 * Implements hook_node_info().
 */
function datasource_node_info() {
  $items = array(
    'datasource' => array(
      'name' => t('Datasource'),
      'base' => 'node_content',
      'description' => t('Provides a datasource for hiera lookups.'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => t('Enter the datasource title, such as \'production:redhat:host.example.com\' as the title of this node.'),
    ),
  );
  return $items;
}
