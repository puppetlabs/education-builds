<?php
/**
 * @file
 * datasource.features.field.inc
 */

/**
 * Implements hook_field_default_fields().
 */
function datasource_field_default_fields() {
  $fields = array();

  // Exported field: 'node-datasource-field_description'.
  $fields['node-datasource-field_description'] = array(
    'field_config' => array(
      'active' => '1',
      'cardinality' => '1',
      'deleted' => '0',
      'entity_types' => array(),
      'field_name' => 'field_description',
      'foreign keys' => array(
        'format' => array(
          'columns' => array(
            'format' => 'format',
          ),
          'table' => 'filter_format',
        ),
      ),
      'indexes' => array(
        'format' => array(
          0 => 'format',
        ),
      ),
      'locked' => '0',
      'module' => 'text',
      'settings' => array(),
      'translatable' => '0',
      'type' => 'text_long',
    ),
    'field_instance' => array(
      'bundle' => 'datasource',
      'default_value' => NULL,
      'deleted' => '0',
      'description' => 'You may optionally provide a description of your datasource.',
      'display' => array(
        'default' => array(
          'label' => 'above',
          'module' => 'text',
          'settings' => array(),
          'type' => 'text_default',
          'weight' => '0',
        ),
        'teaser' => array(
          'label' => 'above',
          'module' => 'text',
          'settings' => array(
            'trim_length' => 600,
          ),
          'type' => 'text_trimmed',
          'weight' => '0',
        ),
      ),
      'entity_type' => 'node',
      'field_name' => 'field_description',
      'label' => 'Description',
      'required' => 0,
      'settings' => array(
        'text_processing' => '1',
        'user_register_form' => FALSE,
      ),
      'widget' => array(
        'active' => 1,
        'module' => 'text',
        'settings' => array(
          'rows' => '3',
        ),
        'type' => 'text_textarea',
        'weight' => '1',
      ),
    ),
  );

  // Exported field: 'node-datasource-field_key'.
  $fields['node-datasource-field_key'] = array(
    'field_config' => array(
      'active' => '1',
      'cardinality' => '-1',
      'deleted' => '0',
      'entity_types' => array(),
      'field_name' => 'field_key',
      'foreign keys' => array(),
      'indexes' => array(),
      'locked' => '0',
      'module' => 'composed_field',
      'settings' => array(),
      'translatable' => '0',
      'type' => 'composed_field',
    ),
    'field_instance' => array(
      'bundle' => 'datasource',
      'default_value' => array(
        0 => array(
          'composed' => array(
            1 => '',
            2 => '',
          ),
        ),
      ),
      'deleted' => '0',
      'description' => '',
      'display' => array(
        'default' => array(
          'label' => 'above',
          'module' => 'composed_field',
          'settings' => array(
            'display_options' => array(
              'format' => '_none',
              'hidden' => 0,
              'prefix' => '',
              'suffix' => '',
            ),
            'table' => array(
              'column_label' => '',
              'number_column' => FALSE,
              'number_column_label' => '№',
            ),
          ),
          'type' => 'composed_field_table',
          'weight' => '1',
        ),
        'teaser' => array(
          'label' => 'above',
          'settings' => array(),
          'type' => 'hidden',
          'weight' => 0,
        ),
      ),
      'entity_type' => 'node',
      'field_name' => 'field_key',
      'label' => 'Key',
      'required' => 0,
      'settings' => array(
        'user_register_form' => FALSE,
      ),
      'widget' => array(
        'active' => 1,
        'module' => 'composed_field',
        'settings' => array(
          'composed_field' => array(
            'access' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'after_build' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'ajax' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'attached' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'attributes' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'autocomplete_path' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'collapsed' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'collapsible' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'cols' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'default_tab' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'default_value' => array(
              1 => array(
                'value' => '',
              ),
              2 => array(
                'value' => '',
              ),
            ),
            'delta' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'description' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'disabled' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'element_validate' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'empty' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'empty_option' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'empty_value' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'field_prefix' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'field_suffix' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'header' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'instance__widget__settings__composed_field__active_tab' => 'edit-instance-widget-settings-composed-field-type',
            'js_select' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'maxlength' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'multiple' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'options' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'parents' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'post_render' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'pre_render' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'prefix' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'process' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'required' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'resizable' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'return_value' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'rows' => array(
              1 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => FALSE,
                'value' => '',
              ),
            ),
            'size' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'states' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'suffix' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'theme' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'theme_wrappers' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'title' => array(
              1 => array(
                'enable_this_attribute' => 1,
                'value' => 'Key',
              ),
              2 => array(
                'enable_this_attribute' => 1,
                'value' => 'Value',
              ),
            ),
            'title_display' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'tree' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'type' => array(
              1 => array(
                'value' => 'textfield',
              ),
              2 => array(
                'value' => 'textfield',
              ),
            ),
            'value_callback' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
            'weight' => array(
              1 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
              2 => array(
                'enable_this_attribute' => 0,
                'value' => '',
              ),
            ),
          ),
          'inline' => 1,
          'number_of_subfields' => '2',
        ),
        'type' => 'composed_field_widget',
        'weight' => '2',
      ),
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('Description');
  t('Key');
  t('You may optionally provide a description of your datasource.');

  return $fields;
}
